# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{integrity}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nicol\303\241s Sanguinetti", "Simon Rozet"]
  s.date = %q{2009-01-14}
  s.default_executable = %q{integrity}
  s.description = %q{Your Friendly Continuous Integration server. Easy, fun and painless!}
  s.email = %q{contacto@nicolassanguinetti.info}
  s.executables = ["integrity"]
  s.files = ["README.markdown", "Rakefile", "TODO", "VERSION.yml", "app.rb", "bin/integrity", "config/config.sample.ru", "config/config.sample.yml", "config/thin.sample.yml", "integrity.gemspec", "lib/integrity.rb", "lib/integrity/build.rb", "lib/integrity/core_ext/object.rb", "lib/integrity/core_ext/string.rb", "lib/integrity/core_ext/time.rb", "lib/integrity/helpers.rb", "lib/integrity/installer.rb", "lib/integrity/migrations.rb", "lib/integrity/notifier.rb", "lib/integrity/notifier/base.rb", "lib/integrity/project.rb", "lib/integrity/project_builder.rb", "lib/integrity/scm.rb", "lib/integrity/scm/git.rb", "lib/integrity/scm/git/uri.rb", "public/buttons.css", "public/reset.css", "public/spinner.gif", "vendor/rack-contrib", "vendor/sinatra", "vendor/sinatra-diddies", "vendor/sinatra-hacks/lib/hacks.rb", "views/build.haml", "views/build_info.haml", "views/error.haml", "views/home.haml", "views/integrity.sass", "views/layout.haml", "views/new.haml", "views/not_found.haml", "views/notifier.haml", "views/project.builder", "views/project.haml", "views/unauthorized.haml", "vendor/sinatra/lib/sinatra", "vendor/sinatra/lib/sinatra/base.rb", "vendor/sinatra/lib/sinatra/compat.rb", "vendor/sinatra/lib/sinatra/images", "vendor/sinatra/lib/sinatra/images/404.png", "vendor/sinatra/lib/sinatra/images/500.png", "vendor/sinatra/lib/sinatra/main.rb", "vendor/sinatra/lib/sinatra/test", "vendor/sinatra/lib/sinatra/test/rspec.rb", "vendor/sinatra/lib/sinatra/test/spec.rb", "vendor/sinatra/lib/sinatra/test/unit.rb", "vendor/sinatra/lib/sinatra/test.rb", "vendor/sinatra/lib/sinatra.rb", "vendor/sinatra-diddies/lib/diddies", "vendor/sinatra-diddies/lib/diddies/authorization.rb", "vendor/sinatra-diddies/lib/diddies/mailer.rb", "vendor/sinatra-diddies/lib/diddies.rb", "vendor/rack-contrib/lib/rack", "vendor/rack-contrib/lib/rack/contrib", "vendor/rack-contrib/lib/rack/contrib/bounce_favicon.rb", "vendor/rack-contrib/lib/rack/contrib/callbacks.rb", "vendor/rack-contrib/lib/rack/contrib/etag.rb", "vendor/rack-contrib/lib/rack/contrib/evil.rb", "vendor/rack-contrib/lib/rack/contrib/garbagecollector.rb", "vendor/rack-contrib/lib/rack/contrib/jsonp.rb", "vendor/rack-contrib/lib/rack/contrib/lighttpd_script_name_fix.rb", "vendor/rack-contrib/lib/rack/contrib/locale.rb", "vendor/rack-contrib/lib/rack/contrib/mailexceptions.rb", "vendor/rack-contrib/lib/rack/contrib/nested_params.rb", "vendor/rack-contrib/lib/rack/contrib/post_body_content_type_parser.rb", "vendor/rack-contrib/lib/rack/contrib/proctitle.rb", "vendor/rack-contrib/lib/rack/contrib/profiler.rb", "vendor/rack-contrib/lib/rack/contrib/sendfile.rb", "vendor/rack-contrib/lib/rack/contrib/time_zone.rb", "vendor/rack-contrib/lib/rack/contrib.rb"]
  s.homepage = %q{http://integrityapp.com}
  s.post_install_message = %q{Run `integrity help` for information on how to setup Integrity.}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{integrity}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The easy and fun Continuous Integration server}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_runtime_dependency(%q<dm-core>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<dm-validations>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<dm-types>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<dm-timestamps>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<dm-aggregates>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<data_objects>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<do_sqlite3>, [">= 0.9.5"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_runtime_dependency(%q<bcrypt-ruby>, [">= 0"])
    else
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<dm-core>, [">= 0.9.5"])
      s.add_dependency(%q<dm-validations>, [">= 0.9.5"])
      s.add_dependency(%q<dm-types>, [">= 0.9.5"])
      s.add_dependency(%q<dm-timestamps>, [">= 0.9.5"])
      s.add_dependency(%q<dm-aggregates>, [">= 0.9.5"])
      s.add_dependency(%q<data_objects>, [">= 0.9.5"])
      s.add_dependency(%q<do_sqlite3>, [">= 0.9.5"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<dm-core>, [">= 0.9.5"])
    s.add_dependency(%q<dm-validations>, [">= 0.9.5"])
    s.add_dependency(%q<dm-types>, [">= 0.9.5"])
    s.add_dependency(%q<dm-timestamps>, [">= 0.9.5"])
    s.add_dependency(%q<dm-aggregates>, [">= 0.9.5"])
    s.add_dependency(%q<data_objects>, [">= 0.9.5"])
    s.add_dependency(%q<do_sqlite3>, [">= 0.9.5"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<bcrypt-ruby>, [">= 0"])
  end
end
