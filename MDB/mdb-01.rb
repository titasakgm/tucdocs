#!/usr/bin/ruby

require 'ffi'

class MDB
  extend FFI::Library
  
  # The lib name gets spackled with platform-specific 
  # prefix and suffix. On Mac OS X, e.g., the ffi_lib
  # name turns into 'libmdb.dylib'
  ffi_lib 'mdb'
  
  # Who needs enum, anyway?
  NOFLAGS = 0
  MDB_TABLE = 1
  
  attach_function :mdb_init, [], :void
  attach_function :mdb_exit, [], :void
  
  # In the libmdb headers, you'll find that this function
  # actually returns a pointer to an MDBHandle struct.  
  # FFI::Struct would likely help out here, but just
  # calling the return result a :pointer works for now.
  attach_function :mdb_open, [ :string, :int], :pointer
  attach_function :mdb_close, [ :pointer], :void 
    
  def self.open(path)
    MDB.mdb_init
    db = MDB.mdb_open( path, MDB::NOFLAGS)
    
    yield db
    
    MDB.mdb_close(db)
    MDB.mdb_exit
  end
  
  attach_function :mdb_dump_catalog, [:pointer, :int], :pointer
    
end

MDB.open('test.mdb') do |db|
  MDB.mdb_dump_catalog(db, MDB::MDB_TABLE)
end
