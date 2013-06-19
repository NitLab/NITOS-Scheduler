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
# Syntax: add_to_AM_config.rb [slice_name]
#
# == Description
#
# This script is used to save the new slice-name in the aggregate manager of omf-5.4.
# Called by the scheduler script create_slice.
#

require "mysql"
require "rubygems"
require "dbi"

$db = ""
$user = ""
$pass = ""
new_id = 0

ARGV.each do |slice_name|
	# Add slice to AM of OMF
	@original_string = "\"default_slice\""
	@replacement_string = "\"default_slice\", \"#{slice_name}\""

	file_name =  "/etc/omf-aggmgr-5.4/omf-aggmgr.yaml"

  	text = File.read(file_name)
  	replace = text.gsub!(@original_string, @replacement_string)
  	File.open(file_name, "w") { |file| file.puts replace }

	# Add slice to NITOS Scheduler database
	#puts "Connecting to database..."
	dbh = DBI.connect("DBI:Mysql:#{$db}:localhost","#{$user}", "#{$pass}")

	dbh.do("INSERT INTO slices (slice_name) VALUES ('#{slice_name}')")
	id = dbh.prepare("SELECT id FROM slices WHERE slice_name = '#{slice_name}'")
	id.execute()
	id.fetch do |n|
		new_id = n[0].to_s
	end
	puts new_id.rjust(3, '0')
end
