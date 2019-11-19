#ifndef _ots_UDPDataStreamerConsumer_h_
#define _ots_UDPDataStreamerConsumer_h_

#include "otsdaq/Configurable/Configurable.h"
#include "otsdaq/DataManager/DataConsumer.h"
#include "otsdaq/NetworkUtilities/UDPDataStreamerBase.h"

#include <string>

namespace ots
{
class ConfigurationTree;

class UDPDataStreamerConsumer : public UDPDataStreamerBase, public DataConsumer, public Configurable
{
  public:
	UDPDataStreamerConsumer(std::string              supervisorApplicationUID,
	                        std::string              bufferUID,
	                        std::string              processorUID,
	                        const ConfigurationTree& theXDAQContextConfigTree,
	                        const std::string&       configurationPath);
	virtual ~UDPDataStreamerConsumer(void);

  protected:
	bool workLoopThread(toolbox::task::WorkLoop* workLoop);

	void fastRead(void);
	void slowRead(void);

	// For fast read
	std::string*                        dataP_;
	std::map<std::string, std::string>* headerP_;
	// For slow read
	std::string                        data_;
	std::map<std::string, std::string> header_;
};

}  // namespace ots

#endif
