#ifndef _ots_FESupervisor_h_
#define _ots_FESupervisor_h_

#include "otsdaq-core/CoreSupervisors/CoreSupervisorBase.h"

namespace ots
{
class FEVInterfacesManager;

//FESupervisor
//	This class handles a collection of front-end interface plugins. It
//	provides an interface to Macro Maker for writes and reads to the front-end interfaces.
class FESupervisor : public CoreSupervisorBase
{
	//friend FEVInterface;

  public:
	XDAQ_INSTANTIATOR ();

	FESupervisor (xdaq::ApplicationStub* s);
	virtual ~FESupervisor (void);

	xoap::MessageReference         frontEndCommunicationRequest (xoap::MessageReference message);
	xoap::MessageReference         macroMakerSupervisorRequest (xoap::MessageReference message);
	virtual xoap::MessageReference workLoopStatusRequest (xoap::MessageReference message);

  protected:
	FEVInterfacesManager* theFEInterfacesManager_;

  private:
	FEVInterfacesManager* extractFEInterfacesManager ();  //likely, just used in constructor
};

}  // namespace ots

#endif
