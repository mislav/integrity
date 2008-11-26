module Integrity
  class Build
    include DataMapper::Resource

    property :id,                   Integer,  :serial => true
    property :output,               Text,     :nullable => false, :default => ""
    property :successful,           Boolean,  :nullable => false, :default => false
    property :status,               String,   :nullable => false, :default => "pending"
    property :commit_identifier,    String,   :nullable => false
    property :commit_metadata,      Yaml,     :nullable => false, :lazy => false
    property :committed_at,         DateTime
    property :created_at,           DateTime
    property :started_building_at,  DateTime
    property :finished_building_at, DateTime

    belongs_to :project, :class_name => "Integrity::Project"

    def successful?
      status == "successful"
    end

    def failed?
      status == "failed"
    end
    
    def pending?
      status == "pending"
    end

    def built?
      !pending?
    end
    
    def human_readable_status
      case status
        when "successful" then "Build Successful"
        when "failed"     then "Build Failed"
        when "pending"    then "Waiting..."
      end
    end

    def short_commit_identifier
      commit_identifier.to_s[0..6]
    end

    def commit_author
      @author ||= begin
        commit_metadata[:author] =~ /^(.*) <(.*)>$/
        OpenStruct.new(:name => $1.strip, :email => $2.strip, :full => commit_metadata[:author])
      end
    end

    def commit_message
      commit_metadata[:message]
    end

    def commited_at
      case commit_metadata[:date]
        when String then Time.parse(commit_metadata[:date])
        else commit_metadata[:date]
      end
    end
  end
end
