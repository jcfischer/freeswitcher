#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "..", 'lib', 'fsr')
require "fsr/listener/outbound"
$stdout.flush

FSR.load_all_applications
FSR.load_all_commands
class DtmfDemo < FSR::Listener::Outbound

  def session_initiated
    exten = @session.headers[:caller_caller_id_number]
    FSR::Log.info "*** Answering incoming call from #{exten}"

    ###############################
    ## NEW STATE MACHINE TEST     #
    ###############################
    answer {
      FSR::Log.info "*** Reading dtmf for #{exten}"
      read("/home/freeswitch/freeswitch/sounds/music/8000/sweet.wav",4,10,"test",15000) {
        FSR::Log.info "*** updating session for #{exten}"
        update_session {
          FSR::Log.info "** Success, grabbed #{@session.headers[:variable_test].strip} from #{exten}"
          FSR::Log.info "*** Hanging up call"
          hangup # Hangup the call
        }
      }
    }
  end
end

FSR.start_oes! DtmfDemo, :port => 8084, :host => "127.0.0.1"
