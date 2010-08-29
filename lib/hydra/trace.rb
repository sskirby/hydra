module Hydra #:nodoc:
  # Trace output when in verbose mode.
  module Trace
    REMOTE_IDENTIFIER = 'REMOTE'

    module ClassMethods
      # Make a class traceable. Takes one parameter,
      # which is the prefix for the trace to identify this class
      def traceable(prefix = self.class.to_s)
        include Hydra::Trace::InstanceMethods
        class << self; attr_accessor :_traceable_prefix; end
        self._traceable_prefix = prefix
        $stdout.sync = true
      end
    end

    module InstanceMethods
      # Trace some output with the class's prefix and a newline.
      # Checks to ensure we're running verbosely.
      def trace(str, force = false)
        remote_info = @remote ? "#{REMOTE_IDENTIFIER} #{@remote} " : ''
        $stdout.write "#{Time.now.to_f} #{remote_info}#{self.class._traceable_prefix}| #{str}\n" if @verbose || force
      end

      def trace_ex(ex)
        trace format_exception(ex), true
      end

      def format_exception(ex)
        "#{ex.class.name}: #{ex.message}\n    #{ex.backtrace.join("\n    ")}"
      end
    end
  end
end
Object.extend(Hydra::Trace::ClassMethods)
