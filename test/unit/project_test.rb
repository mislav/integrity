require File.dirname(__FILE__) + "/../helpers"

class ProjectTest < Test::Unit::TestCase
  before(:each) do
    RR.reset
    setup_and_reset_database!
    ignore_logs!
  end

  specify "default fixture is valid and can be saved" do
    lambda do
      Project.generate.tap do |project|
        project.should be_valid
        project.save
      end
    end.should change(Project, :count).by(1)
  end

  specify "integrity fixture is valid and can be saved" do
    lambda do
      Project.generate(:integrity).tap do |project|
        project.should be_valid
        project.save
      end
    end.should change(Project, :count).by(1)
  end

  describe "Properties" do
    before(:each) do
      @project = Project.generate(:integrity)
    end

    it "has a name" do
      @project.name.should == "Integrity"
    end

    it "has a permalink" do
      @project.permalink.should == "integrity"

      @project.tap do |project|
        project.name = "foo's bar/baz and BACON?!"
        project.save
      end.permalink.should == "foos-bar-baz-and-bacon"
    end

    it "has an URI" do
      @project.uri.should == Addressable::URI.parse("git://github.com/foca/integrity.git")
    end

    it "has a branch" do
      @project.branch.should == "master"
    end

    specify "branch defaults to master" do
      Project.new.branch.should == "master"
    end

    it "has a command" do
      # TODO: rename to build_command
      @project.command.should == "rake"
    end

    specify "command defaults to 'rake'" do
      Project.new.command.should == "rake"
    end

    it "has a building flag" do
      @project.should_not be_building
    end

    specify "building flag default to false" do
      Project.new.should_not be_building
    end

    it "knows it's visibility" do
      # TODO: rename Project#public property to visibility
      # TODO: and have utility method to query its state instead

      Project.new.should be_public

      @project.should be_public
      @project.tap { |p| p.public = "1" }.should be_public
      @project.tap { |p| p.public = "0" }.should_not be_public

      Project.gen(:public => "false").should be_public
      Project.gen(:public => "true").should be_public
      Project.gen(:public => false).should_not be_public
      Project.gen(:public => nil).should_not be_public
    end

    it "has a created_at" do
      @project.created_at.should be_a(DateTime)
    end

    it "has an updated_at" do
      @project.updated_at.should be_a(DateTime)
    end

    it "knows it's status" do
      Project.gen(:builds => 1.of{Build.make(:successful => true )}).status.should == :success
      Project.gen(:builds => 2.of{Build.make(:successful => true )}).status.should == :success
      Project.gen(:builds => 2.of{Build.make(:successful => false)}).status.should == :failed
      Project.gen(:builds => []).status.should be_nil
    end

    it "knows it's last build" do
      Project.gen(:builds => []).last_build.should be_nil

      project = Project.gen(:builds => (builds = 5.of{Build.make(:successful => true)}))
      project.last_build.should == builds.sort_by {|build| build.created_at }.last
    end
  end

  describe "Validation" do
    it "requires a name" do
      lambda do
        Project.gen(:name => nil).should_not be_valid
      end.should_not change(Project, :count)
    end

    it "requires an URI" do
      lambda do
        Project.gen(:uri => nil).should_not be_valid
      end.should_not change(Project, :count)
    end

    it "requires a branch" do
      lambda do
        Project.gen(:branch => nil).should_not be_valid
      end.should_not change(Project, :count)
    end

    it "requires a command" do
      lambda do
        Project.gen(:command => nil).should_not be_valid
      end.should_not change(Project, :count)
    end

    it "ensures its name is unique" do
      Project.gen(:name => "Integrity")
      lambda do
        Project.gen(:name => "Integrity").should_not be_valid
      end.should_not change(Project, :count)
    end
  end
  
  describe "Finding public or private projects" do
    before(:each) do
      @public_project = Project.gen(:public => true)
      @private_project = Project.gen(:public => false)
    end
    
    it "finds only public projects if the condition passed is false" do
      projects = Project.only_public_unless(false)
      projects.should_not include(@private_project)
      projects.should include(@public_project)
    end
    
    it "finds both private and public projects if the condition passed is true" do
      projects = Project.only_public_unless(true)
      projects.should include(@private_project)
      projects.should include(@public_project)
    end
  end

  describe "When finding its previous builds" do
    before(:each) do
      @builds = 5.of { Build.gen }
      @project = Project.generate(:builds => @builds)
    end

    it "has 4 previous builds" do
      @project.should have(4).previous_builds
    end

    it "returns the builds ordered chronogicaly (desc) by creation date" do
      builds_sorted_by_creation_date = @builds.sort_by {|build| build.created_at }.reverse
      @project.previous_builds.should == builds_sorted_by_creation_date[1..-1]
    end

    it "excludes the last build" do
      @project.previous_builds.should_not include(@project.last_build)
    end

    it "returns an empty array if it has only one build" do
      project = Project.gen(:builds => 1.of { Integrity::Build.make })
      project.should have(:no).previous_builds
    end

    it "returns an empty array if there are no builds" do
      project = Project.gen(:builds => [])
      project.should have(:no).previous_builds
    end
  end

  describe "When getting destroyed" do
    before(:each) do
      @builds  = (1..7).of { Build.make }
      @project = Project.generate(:builds => @builds)
    end

    it "destroys itself and tell ProjectBuilder to delete the code from disk" do
      lambda do
        stub.instance_of(ProjectBuilder).delete_code
        @project.destroy
      end.should change(Project, :count).by(-1)
    end

    it "destroys its builds" do
      lambda do
        @project.destroy
      end.should change(Build, :count).by(-@builds.length)
    end
  end

  describe "When retrieving state about its notifier" do
    before(:each) do
      @project = Project.generate
      @irc     = Notifier.generate(:irc)
    end

    specify "#config_for returns given notifier's configuration" do
      @project.update_attributes(:notifiers => [@irc])
      @project.config_for("IRC").should == {:uri => "irc://irc.freenode.net/integrity"}
    end

    specify "#config_for returns an empty hash if no such notifier" do
      @project.config_for("IRC").should == {}
    end

    specify "#notifies? is true if it uses the given notifier" do
      @project.update_attributes(:notifiers => [@irc])
      @project.notifies?("IRC").should == true
    end

    specify "#notifies? is false if it doesnt use the given notifier" do
      @project.update_attributes(:notifiers => [])

      @project.notifies?("IRC").should == false
      @project.notifies?("UndefinedNotifier").should == false
    end
  end

  describe "When building a build" do
    before(:each) do
      @builds  = (1..7).of { Build.make }
      @project = Project.generate(:integrity, :builds => @builds)
      stub.instance_of(ProjectBuilder).build { nil }
    end

    it "builds the given commit identifier and handle its building state" do
      @project.should_not be_building
      lambda do
        mock.instance_of(Integrity::ProjectBuilder).build("foo") { @project.should be_building }
        @project.build("foo")
      end.should_not change(@project, :building)
    end

    it "don't build if it is already building" do
      @project.update_attributes(:building => true)
      do_not_call(ProjectBuilder).build
      @project.build
    end

    it "builds HEAD by default" do
      mock.instance_of(Integrity::ProjectBuilder).build("HEAD")
      @project.build
    end

    it "sends notifications with all registered notifiers" do
      irc     = Integrity::Notifier.make(:irc)
      twitter = Integrity::Notifier.make(:twitter)
      @project.update_attributes(:notifiers => [irc, twitter])

      mock.proxy(Integrity::Notifier::IRC).notify_of_build(@project.last_build, :uri => "irc://irc.freenode.net/integrity")
      mock.proxy(Integrity::Notifier::Twitter).notify_of_build(@project.last_build, :email => "foo@example.org", :pass => "secret")
      
      @project.build
    end

    it "still sends notification even if one of the notifier timeout" do
      irc     = Integrity::Notifier.make(:irc)
      twitter = Integrity::Notifier.make(:twitter)
      @project.update_attributes(:notifiers => [irc, twitter])

      mock.proxy(Integrity::Notifier::Twitter).notify_of_build(@project.last_build, anything) do
        raise Timeout::Error, "I've timed out, boo"
      end
      mock.proxy(Integrity::Notifier::IRC).notify_of_build(@project.last_build, anything)

      @project.build
    end
  end

  it "doesn't have weird, wtf-ish bugs" do
    success = Project.gen(:builds => 10.of{Build.make(:successful => true)})
    failure = Project.gen(:builds => 10.of{Build.make(:successful => false)})
    unbuild = Project.gen

    Build.count.should == 20
    success.should have(10).builds
    failure.should have(10).builds
    unbuild.should have(0).builds

    success.last_build.should be_successful
    failure.last_build.should be_failed
    unbuild.last_build.should be_nil

    Project.all.each do |project|
      case project
      when success
        project.last_build.should be_successful
      when failure
        project.id.should == failure.id
        project.last_build.should be_failed
      when unbuild
        project.last_build.should be_nil
      end
    end
  end
end
