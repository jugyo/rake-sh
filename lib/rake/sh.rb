require 'readline'
require 'rake'
require 'rake/sh/command'
require 'rake/sh/commands'

module Rake
  module Sh
    class << self
      def start(eager_tasks = [])
        rake_init
        eager_tasks.each { |task| ::Rake.application[task].invoke }
        setup_readline

        while buf = Readline.readline("rake> ", true)
          line = buf.strip
          next if line.empty?
          begin
            execute(line)
          rescue SystemExit
            raise
          rescue Exception => e
            puts "\e[41m#{e.message}\n#{e.backtrace.join("\n")}\e[0m"
          end
          setup_readline
        end
      end

      def execute(line)
        if command = Command.find(line)
          arg = line.split(/\s+/, 2)[1] rescue nil
          command.call(arg)
        else
          invoke(line.strip)
        end
      end

      def setup_readline
        Readline.basic_word_break_characters = ""
        Readline.completion_proc = lambda do |word|
          (
            Command.command_names.map { |name| name.to_s } +
            Rake.application.tasks.map{ |t| t.name }
          ).grep(/#{Regexp.quote(word)}/)
        end
      end

      def rake_init
        Rake.application = Rake::Application.new
        Rake.application.init
        Rake.application.load_rakefile
      end

      def invoke(name)
        Process.waitpid(fork { ::Rake.application[name].invoke })
      end
    end
  end
end