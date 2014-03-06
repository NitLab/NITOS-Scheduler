#
# Copyright (c) 2009-2011 NITLab, University of Thessaly, CERTH, Greece
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# = frequencies_check.rb
#
# == Description
#
# This file checks the scheduler database for the frequencies that users reserved
# for this time slot. After that it logs to a file the possible frequency misuse.
# This file should by executed automatically by crontab as scheduler user.
# The public key of scheduler user should be in authorized_keys file of root home 
# folder at each active node's filesystem.
#

require 'rubygems'
require 'net/ssh'
require 'logger'
require "dbi"

log = Logger.new('log', shift_age = 'weekly')
#get current time
channel_reg = /Channel\s([0-9]*)/
time = Time.new
cur_time = time.strftime("%Y-%m-%d %H:%M:%S")
#log.debug cur_time
con = Mysql.new('localhost', '', '', '')
query = "select reservation.username, node_list.name from reservation join node_list on reservation.node_id=node_list.id where '#{cur_time}'>reservation.begin_time and '#{cur_time}'<reservation.end_time"
rs = con.query(query)
rs.each_hash do |h|
  channel_1 = nil
  channel_2 = nil
  #ssh node name and get frequency from iwlist.
  begin
    Timeout::timeout(3) do
      begin
        Net::SSH.start( h['name'], 'root', :paranoid => false ) do|ssh|
          ssh_channel_1 = ssh.exec!('iwlist ath0 channel | grep Current')
          channel_1 = channel_reg.match(ssh_channel_1)
          ssh_channel_2 = ssh.exec!('iwlist ath1 channel | grep Current')
          channel_2 = channel_reg.match(ssh_channel_2)
        end
      rescue Exception => ex
        log.debug "#{h['name']}, #{h['username']}: " + ex.to_s
      end
    end
  rescue Timeout::Error
    log.debug "#{h['name']}, #{h['username']}: Timed out trying to get a connection"
  end  
  
  if (channel_1 != nil)
    queryc = "select spec_reserve.id from spec_reserve join spectrum on spec_reserve.spectrum_id=spectrum.id where spec_reserve.username='#{h['username']}' and spectrum.channel='#{channel_1[1]}' and '#{cur_time}'>spec_reserve.begin_time and '#{cur_time}'<spec_reserve.end_time"
    rsc = con.query(queryc)    
    if rsc.num_rows == 0 then
      log.debug "#{h['name']}, #{h['username']}: Channel misuse"      
    else
      #log.debug "OK"
    end    
  end
  
  if (channel_2 != nil) 
    queryc = "select spec_reserve.id from spec_reserve join spectrum on spec_reserve.spectrum_id=spectrum.id where spec_reserve.username='#{h['username']}' and spectrum.channel='#{channel_2[1]}' and '#{cur_time}'>spec_reserve.begin_time and '#{cur_time}'<spec_reserve.end_time"
    rsc = con.query(queryc)
    if rsc.num_rows == 0 then
      log.debug "#{h['name']}, #{h['username']}: Channel misuse"
    else
      #log.debug "OK"
    end
  end
    
end

con.close
