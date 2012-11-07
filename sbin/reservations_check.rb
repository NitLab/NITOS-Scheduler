#
# Copyright (c) 2009-2012 NITLab, University of Thessaly, CERTH, Greece
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
# = reservations_check.rb
#
# == Description
#
# This file checks the scheduler database for the reservations that end or begin
# at the next time slot. After that it disables and/or enables the proper nodes.
# This file should by executed automatically by crontab as root.
#

require 'mysql'

# Get current time and transform it based on the time slots we use (half an hour time slots).
# Note that we execute the script at minutes 28 and 58.
time = Time.new
if (time.min < 30)
  next_slot = time.strftime("%Y-%m-%d %H:30:00")
else
  time += 3600
  next_slot = time.strftime("%Y-%m-%d %H:00:00")
end

# Connect to scheduler database.
con = Mysql.new("localhost", "", "", "")

#------------ Disable Nodes -------------------
query = "select reservation.username, node_list.y from reservation join node_list on reservation.node_id=node_list.id where reservation.end_time='#{next_slot}'"
rs = con.query(query)
rs.each_hash do |h|
  cmd = `disable_node #{h["username"]} #{h["y"]}`
end

#------------ Enable Nodes --------------------
query = "select reservation.username, node_list.y from reservation join node_list on reservation.node_id=node_list.id where reservation.begin_time='#{next_slot}'"
rs = con.query(query)
rs.each_hash do |h|
  cmd = `enable_node #{h["username"]} #{h["y"]}`
end

con.close
