#ifndef _ots_TCPClientBase_h_
#define _ots_TCPClientBase_h_

#include <netinet/in.h>
#include <string>
#include "otsdaq-core/NetworkUtilities/TCPTransceiverSocket.h"

namespace ots
{
class TCPClientBase : public virtual TCPSocket
{
  public:
	// TCPClientBase();
	TCPClientBase(const std::string& serverIP, int serverPort);
	virtual ~TCPClientBase(void);

	bool connect(int retry = -1, unsigned int sleepMSeconds = 1000);

  private:
	std::string fServerIP;
	int         fServerPort;
	bool        fConnected;

	void resolveServer(std::string& serverIP);
};
}
#endif
