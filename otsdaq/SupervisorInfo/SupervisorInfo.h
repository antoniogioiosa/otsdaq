#ifndef _ots_SupervisorInfo_h_
#define _ots_SupervisorInfo_h_

#include <string>
#include "otsdaq/Macros/CoutMacros.h" /* also for XDAQ_CONST_CALL */
#include "otsdaq/TablePlugins/XDAQContextTable.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#pragma GCC diagnostic ignored "-Wunused-variable"
#pragma GCC diagnostic ignored "-Wunused-parameter"
#if __GNUC__ >= 8
#pragma GCC diagnostic ignored "-Wcatch-value"
#endif
#include "xdaq/Application.h"       /* for  xdaq::ApplicationDescriptor */
#include "xdaq/ContextDescriptor.h" /* for  xdaq::ContextDescriptor */
#pragma GCC diagnostic pop
#include "otsdaq/Macros/XDAQApplicationMacros.h"

// clang-format off
namespace ots
{
class SupervisorInfo
{
  public:
	// when no configuration, e.g. Wizard Mode, then
	// name and contextName are derived from the class name and LID
	SupervisorInfo(XDAQ_CONST_CALL xdaq::ApplicationDescriptor* descriptor, const std::string& name, const std::string& contextName)
	    : descriptor_(descriptor)
	    , contextDescriptor_(descriptor ? descriptor->getContextDescriptor() : 0)
	    , name_(name)
	    ,  // this is the config app name
	    contextName_(contextName)
	    ,  // this is the config parent context name
	    id_(descriptor ? descriptor->getLocalId() : 0)
	    , class_(descriptor ? descriptor->getClassName() : "")
	    , contextURL_(contextDescriptor_ ? contextDescriptor_->getURL() : "")
	    , URN_(descriptor ? descriptor->getURN() : "")
	    , URL_(contextURL_ + "/" + URN_)
	    , port_(0)
	    , status_(SupervisorInfo::APP_STATUS_UNKNOWN)
	{
		// when no configuration, e.g. Wizard Mode, then
		// name and contextName are derived from the class name and LID
		if(name_ == "")
			name_ = id_;
		if(contextName_ == "")
			contextName_ = class_;

		//  __COUTV__(name_);
		//  __COUTV__(contextName_);
		//  __COUTV__(id_);
		//  __COUTV__(contextURL_);
		//  __COUTV__(URN_);
		//  __COUTV__(URL_);
		//  __COUTV__(port_);
		//  __COUTV__(class_);
	}

	~SupervisorInfo(void) { ; }


	static const std::string APP_STATUS_UNKNOWN;

	// BOOLs	-------------------
	bool isGatewaySupervisor(void) const { return class_ == XDAQContextTable::GATEWAY_SUPERVISOR_CLASS; }
	bool isWizardSupervisor(void) const { return class_ == XDAQContextTable::WIZARD_SUPERVISOR_CLASS; }
	bool isTypeFESupervisor(void) const { return XDAQContextTable::FETypeClassNames_.find(class_) != XDAQContextTable::FETypeClassNames_.end(); }
	bool isTypeDMSupervisor(void) const { return XDAQContextTable::DMTypeClassNames_.find(class_) != XDAQContextTable::DMTypeClassNames_.end(); }
	bool isTypeLogbookSupervisor(void) const { return XDAQContextTable::LogbookTypeClassNames_.find(class_) != XDAQContextTable::LogbookTypeClassNames_.end(); }
	bool isTypeMacroMakerSupervisor(void) const	{ return XDAQContextTable::MacroMakerTypeClassNames_.find(class_) != XDAQContextTable::MacroMakerTypeClassNames_.end(); }
	bool isTypeConfigurationGUISupervisor(void) const { return XDAQContextTable::ConfigurationGUITypeClassNames_.find(class_) != XDAQContextTable::ConfigurationGUITypeClassNames_.end(); }
	bool isTypeChatSupervisor(void) const { return XDAQContextTable::ChatTypeClassNames_.find(class_) != XDAQContextTable::ChatTypeClassNames_.end(); }
	bool isTypeConsoleSupervisor(void) const { return XDAQContextTable::ConsoleTypeClassNames_.find(class_) != XDAQContextTable::ConsoleTypeClassNames_.end(); }

	// Getters -------------------
	XDAQ_CONST_CALL xdaq::ApplicationDescriptor* getDescriptor					(void) const { return descriptor_; }
	const xdaq::ContextDescriptor*               getContextDescriptor			(void) const { return contextDescriptor_; }
	const std::string&                           getName						(void) const { return name_; }
	const std::string&                           getContextName					(void) const { return contextName_; }
	const unsigned int&                          getId							(void) const { return id_; }
	const std::string&                           getClass						(void) const { return class_; }
	const std::string&                           getStatus						(void) const { return status_; }
	time_t                                 getLastStatusTime				(void) const { return lastStatusTime_; }
	const unsigned int&                          getProgress					(void) const { return progress_; }
	const std::string&                           getDetail						(void) const { return detail_; }
	const std::string&                           getURL							(void) const { return contextURL_; }
	const std::string&                           getURN							(void) const { return URN_; }
	const std::string&                           getFullURL						(void) const { return URL_; }
	const uint16_t&                              getPort						(void) const { return port_; }

	// Setters -------------------
	void setStatus(const std::string& status, const unsigned int progress, const std::string& detail = "");
	void clear(void);

  private:
	XDAQ_CONST_CALL xdaq::ApplicationDescriptor* descriptor_;
	XDAQ_CONST_CALL xdaq::ContextDescriptor* contextDescriptor_;
	std::string                              name_;
	std::string                              contextName_;
	unsigned int                             id_;
	std::string                              class_;
	std::string                              contextURL_;
	std::string                              URN_;
	std::string                              URL_;
	uint16_t                                 port_;
	std::string                              status_;
	unsigned int                             progress_;
	std::string                              detail_;
	time_t                                   lastStatusTime_;
};
// clang-format on
}  // namespace ots

#endif
