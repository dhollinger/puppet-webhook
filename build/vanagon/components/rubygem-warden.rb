# frozen_string_literal: true

component 'rubygem-warden' do |pkg, _settings, _platform|
  pkg.version '1.2.8'
  instance_eval File.read('build/vanagon/components/_base-rubygem.rb')
end
