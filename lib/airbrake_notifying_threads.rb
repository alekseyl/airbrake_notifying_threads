require "airbrake_notifying_threads/version"
require 'notifying_thread'
require 'airbrake'

module AirbrakeNotifyingThreads
  def run_async_with_rescue( airbrake_params = {} )
    bcktrc = Kernel.caller
    Thread.new {
      begin
        yield
      rescue => e
        e.set_backtrace( bcktrc )
        notice = Airbrake.build_notice(e, airbrake_params)
        Airbrake.notify(notice) if notice
      end
    }
  end
end