#!/usr/bin/ruby

require 'active_mdb'

class Campaign < ActiveMDB::Base
  set_mdb_file 'test.mdb'
  set_table_name 'Campaign_Table'
end

campaign = Campaign.find(1)
puts campaign

