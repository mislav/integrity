module Integrity
  class Project
    include DataMapper::Resource

    property :id,         Integer,  :serial => true
    property :name,       String,   :nullable => false
    property :permalink,  String
    property :uri,        URI,      :nullable => false, :length => 255
    property :branch,     String,   :nullable => false, :default => "master"
    property :command,    String,   :nullable => false, :length => 255, :default => "rake"
    property :public,     Boolean,  :default => true
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :builds, :class_name => "Integrity::Build"
    has n, :notifiers, :class_name => "Integrity::Notifier"

    before :save, :set_permalink
    before :destroy, :delete_code

    validates_is_unique :name

    def build(commit_identifier)
      builds.first_or_create(:commit_identifier => commit_identifier).tap do |build|
        build.update_attributes(:status => "pending", :created_at => Time.now) unless build.pending?
      end
    end
    
    def building?
      !build_in_progress.nil?
    end
    
    def build_in_progress
      builds.first(:started_building_at.not => nil, :finished_building_at => nil)
    end

    def last_build
      builds.last
    end

    def previous_builds
      builds.all(:order => [:created_at.desc]).tap do |builds|
        builds.shift
      end
    end

    def status
      last_build && last_build.status
    end

    def public=(flag)
      attribute_set(:public, !!flag)
    end
    
    def config_for(notifier)
      notifier = notifiers.first(:name => notifier.to_s.split(/::/).last)
      notifier.blank? ? {} : notifier.config
    end
    
    def notifies?(notifier)
      !notifiers.first(:name => notifier.to_s.split(/::/).last).blank?
    end
    
    def enable_notifiers(*args)
      Notifier.enable_notifiers(id, *args)
    end
      
    def send_notifications
      notifiers.each do |notifier|
        notifier.notify_of_build last_build
      end
    end
    
    private
      def set_permalink
        self.permalink = (name || "").downcase.
          gsub(/'s/, "s").
          gsub(/&/, "and").
          gsub(/[^a-z0-9]+/, "-").
          gsub(/-*$/, "")
      end

      def delete_code
        builds.destroy!
        Builder.new(self).delete_code
      end
      
      def send_notifications
        notifiers.each do |notifier|
          begin
            Integrity.log "Notifying of build #{last_build.short_commit_identifier} using the #{notifier.name} notifier"
            notifier.notify_of_build last_build
          rescue Timeout::Error
            Integrity.log "#{notifier.name} notifier timed out"
            next
          end
        end
      end
  end
end
