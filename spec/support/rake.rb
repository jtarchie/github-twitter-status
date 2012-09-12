require 'rake'

module RakeExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :task

    let(:rake)      { Rake::Application.new }
    let(:task_name) { self.class.top_level_description }
    let(:task_path) { "lib/tasks/#{task_name.split(":").first}" }
    subject         { rake[task_name] }

    def loaded_files_excluding_current_rake_file
      $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
    end

    before do
      Rake.application = rake
      Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

      Rake::Task.define_task(:environment)
    end
  end

  RSpec.configure do |config|
    config.include self, :example_group => { :file_path => %r(spec/tasks) }
  end
end