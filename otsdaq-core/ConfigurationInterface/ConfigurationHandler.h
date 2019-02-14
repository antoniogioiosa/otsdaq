#ifndef _ots_ConfigurationHandler_h_
#define _ots_ConfigurationHandler_h_

#include <string>
#include <xercesc/dom/DOMDocument.hpp>
#include <xercesc/util/XMLChar.hpp>
#include "otsdaq-core/ConfigurationDataFormats/ConfigurationVersion.h"

namespace ots
{
class ConfigurationBase;

class ConfigurationHandler
{
  public:
	ConfigurationHandler (void);
	virtual ~ConfigurationHandler (void);
	virtual void read (ConfigurationBase& configuration)
	{
		;
	}
	virtual void write (const ConfigurationBase& configuration)
	{
		;
	}

	static void        readXML (ConfigurationBase& configuration, ConfigurationVersion version);
	static void        readXML (ConfigurationBase* configuration, ConfigurationVersion version);
	static std::string writeXML (const ConfigurationBase& configuration);  //returns the file name
	static std::string writeXML (const ConfigurationBase* configuration);  //returns the file name

	//FIXME These are methods that should not exist as public but I don't know what to do until I know how to make the database interface
	static std::string getXMLDir (const ConfigurationBase* configuration);

  private:
	static void        initPlatform (void);
	static void        terminatePlatform (void);
	static bool        validateNode (XMLCh* tagName, xercesc::DOMNode* node, const std::string& expectedValue);
	static void        outputXML (xercesc::DOMDocument* pmyDOMDocument, std::string filePath);
	static std::string getXMLFileName (const ConfigurationBase& configuration, ConfigurationVersion version);

	static xercesc::DOMNode*    getNode (XMLCh* tagName, xercesc::DOMNode* parent, unsigned int itemNumber);
	static xercesc::DOMNode*    getNode (XMLCh* tagName, xercesc::DOMElement* parent, unsigned int itemNumber);
	static xercesc::DOMElement* getElement (XMLCh* tagName, xercesc::DOMNode* parent, unsigned int itemNumber);
	static xercesc::DOMElement* getElement (XMLCh* tagName, xercesc::DOMElement* parent, unsigned int itemNumber);
	static XMLCh*               rootTag_;
	static XMLCh*               headerTag_;
	static XMLCh*               typeTag_;
	static XMLCh*               extensionTableNameTag_;
	static XMLCh*               nameTag_;
	static XMLCh*               runTag_;
	static XMLCh*               runTypeTag_;
	static XMLCh*               runNumberTag_;
	static XMLCh*               runBeginTimestampTag_;
	static XMLCh*               locationTag_;
	static XMLCh*               datasetTag_;
	static XMLCh*               versionTag_;
	static XMLCh*               commentDescriptionTag_;
	static XMLCh*               createdByUserTag_;
	static XMLCh*               partTag_;
	static XMLCh*               nameLabelTag_;
	static XMLCh*               kindOfPartTag_;
	static XMLCh*               dataTag_;
};

}  // namespace ots

#endif  //ots_ConfigurationHandler_h
