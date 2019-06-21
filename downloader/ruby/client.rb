this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'filedl_services_pb'

def main
    stub = Filedl::FileService::Stub.new('localhost:50051', :this_channel_is_insecure)
    filename = ARGV[0]
    resps = stub.download(Filedl::FileRequest.new(name: filename))
    blob = ""
    resps.each do |r|
        blob << r.data
    end

    p "done " + blob.size.to_s(10) + " bytes"

    file = File.open(filename,"w")
    file.puts blob
    file.close
end

main