# encoding: utf-8
Gem::Specification.new do |s|
  s.name = 'diag_down'
  s.version = '0.1.0.pre'
  s.summary = "Sequence Diagram Markup language interpreter"
  s.description = 'A markup language for drawing simple sequence diagram in svg'
  s.date = '2012-12-22'
  s.email = 'adanselm@gmail.com'
  s.homepage = 'http://github.com/adanselm/diag_down'
  s.authors = ["Adrien Anselme"]
  # = MANIFEST =
  s.files = %w[
    README.md
    diag_down.gemspec
    lib/diag_down/interpreter.rb
    lib/diag_down/sequence_diag_parser.treetop
    lib/diag_down/svg_renderer.rb
    lib/diag_down.rb
    spec/parser_spec.rb
    spec/spec_helper.rb
    spec/svg_renderer_spec.rb
  ]
  s.require_paths = ["lib"]
  s.add_runtime_dependency "treetop", ["~> 1.4"]
  s.add_runtime_dependency "polyglot", ["~> 0.3"]
  s.add_runtime_dependency "ruby_svg_light", ["~> 0.1"]
end
