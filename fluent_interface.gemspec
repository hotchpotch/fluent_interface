Gem::Specification.new do |s|
  s.name = %q{fluent_interface}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuichi Tateno"]
  s.autorequire = %q{}
  s.date = %q{2008-07-09}
  s.description = %q{}
  s.email = %q{hotchpotch@gmail.com}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/test_fluent_interface.rb", "test/test_helper.rb", "lib/fluent_interface.rb", "examples/webrick_fluent.rb", "examples/example_api.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://fluent_interface.rubyforge.org}
  s.rdoc_options = ["--title", "fluent_interface documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fluent_interface}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{}
  s.test_files = ["test/test_fluent_interface.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
