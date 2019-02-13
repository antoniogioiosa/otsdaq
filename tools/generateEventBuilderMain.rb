# This function will generate the FHiCL code used to control the
# EventBuilderMain application by configuring its
# artdaq::EventBuilderCore object

require File.join( File.dirname(__FILE__), 'generateEventBuilder' )


def generateEventBuilderMain(ebIndex, totalFRs, totalEBs, totalAGs,
                         dataDir,
                         diskWritingEnable, fragSizeWords, totalFragments )
  # Do the substitutions in the event builder configuration given the options
  # that were passed in from the command line.  

  ebConfig = String.new( "\

services: {
  scheduler: {
    fileMode: NOMERGE
  }
  user: {
    NetMonTransportServiceInterface: {
      service_provider: NetMonTransportService
      first_data_receiver_rank: %{ag_rank}
      mpi_buffer_count: %{netmonout_buffer_count}
      max_fragment_size_words: %{size_words}
      data_receiver_count: 1 # %{ag_count}
      #broadcast_sends: true
    }
  }
  Timing: { summaryOnly: true }
  #SimpleMemoryCheck: { }
}

%{event_builder_code}

outputs: {
  %{netmon_output}netMonOutput: {
  %{netmon_output}  module_type: NetMonOutput
  %{netmon_output}}
  %{root_output}normalOutput: {
  %{root_output}  module_type: RootOutput
  %{root_output}  fileName: \"%{output_file}\"
  %{root_output}}
}

physics: {
  %{netmon_output}my_output_modules: [ netMonOutput ]
  %{root_output}my_output_modules: [ normalOutput ]
}
source: {
  module_type: RawInput
  waiting_time: 900
  resume_after_timeout: true
  fragment_type_map: [[1, \"UDP\"]]
}
process_name: DAQ" )

verbose = "true"

if Integer(totalAGs) >= 1
  verbose = "false"
end


event_builder_code = generateEventBuilder( fragSizeWords, totalFRs, totalAGs, totalFragments, verbose)

ebConfig.gsub!(/\%\{event_builder_code\}/, event_builder_code)

ebConfig.gsub!(/\%\{ag_rank\}/, String(totalFRs + totalEBs))
ebConfig.gsub!(/\%\{ag_count\}/, String(totalAGs))
ebConfig.gsub!(/\%\{size_words\}/, String(fragSizeWords))
ebConfig.gsub!(/\%\{netmonout_buffer_count\}/, String(totalAGs*4))

if Integer(totalAGs) >= 1
  ebConfig.gsub!(/\%\{netmon_output\}/, "")
  ebConfig.gsub!(/\%\{root_output\}/, "#")
  ebConfig.gsub!(/\%\{enable_onmon\}/, "#")
  ebConfig.gsub!(/\%\{phys_anal_onmon_cfg\}/, "")
else
  ebConfig.gsub!(/\%\{netmon_output\}/, "#")
  if Integer(diskWritingEnable) != 0
    ebConfig.gsub!(/\%\{root_output\}/, "")
  else
    ebConfig.gsub!(/\%\{root_output\}/, "#")
  end
end


currentTime = Time.now
fileName = "artdaqots_eb%02d_" % ebIndex
fileName += "r%06r_sr%02s_%to"
fileName += ".root"
outputFile = File.join(dataDir, fileName)
ebConfig.gsub!(/\%\{output_file\}/, outputFile)

return ebConfig

end


