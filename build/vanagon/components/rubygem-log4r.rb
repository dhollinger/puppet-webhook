# frozen_string_literal: true

component 'rubygem-log4r' do |pkg, _settings, _platform|
  pkg.version '1.1.10'
  instance_eval File.read('build/vanagon/components/_base-rubygem.rb')
end
