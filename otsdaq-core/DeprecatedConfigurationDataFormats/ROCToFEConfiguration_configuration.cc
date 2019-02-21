#include <iostream>
#include "otsdaq-core/Macros/TablePluginMacros.h"
#include "otsdaq-core/TablePluginDataFormats/ROCToFETable.h"

using namespace ots;

const std::string ROCToFEConfiguration::staticTableName_ = "ROCToFEConfiguration";
//==============================================================================
ROCToFEConfiguration::ROCToFEConfiguration(void)
    : TableBase(ROCToFEConfiguration::staticTableName_)
{
	//////////////////////////////////////////////////////////////////////
	// WARNING: the names and the order MUST match the ones in the enum  //
	//////////////////////////////////////////////////////////////////////
	// ROCToFEConfigurationInfo.xml
	//<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
	//<ROOT xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	// xsi:noNamespaceSchemaLocation="TableInfo.xsd">
	//  <CONFIGURATION Name="ROCToFEConfiguration">
	//    <VIEW Name="ROC_TO_FE_CONFIGURATION" Type="File,Database,DatabaseTest">
	//      <COLUMN Name="DetectorID"       StorageName="DETECTOR_ID"
	//      DataType="VARCHAR2" /> <COLUMN Name="FEWName"       StorageName="FEW_NAME"
	//      DataType="NUMBER"   /> <COLUMN Name="FEWChannel"    StorageName="FEW_CHANNEL"
	//      DataType="NUMBER"   /> <COLUMN Name="FEWROCAddress"
	//      StorageName="FEW_ROC_ADDRESS" DataType="NUMBER"   /> <COLUMN Name="FERName"
	//      StorageName="FER_NAME"        DataType="NUMBER"   /> <COLUMN Name="FERChannel"
	//      StorageName="FER_CHANNEL"     DataType="NUMBER"   /> <COLUMN
	//      Name="FERROCAddress" StorageName="FER_ROC_ADDRESS" DataType="NUMBER"   />
	//    </VIEW>
	//  </CONFIGURATION>
	//</ROOT>
}

//==============================================================================
ROCToFEConfiguration::~ROCToFEConfiguration(void) {}

//==============================================================================
void ROCToFEConfiguration::init(ConfigurationManager* configManager)
{
	std::string tmpDetectorID;
	for(unsigned int row = 0; row < TableBase::activeTableView_->getNumberOfRows(); row++)
	{
		TableBase::activeTableView_->getValue(tmpDetectorID, row, DetectorID);
		nameToInfoMap_[tmpDetectorID] = ROCInfo();
		ROCInfo& aROCInfo             = nameToInfoMap_[tmpDetectorID];
		TableBase::activeTableView_->getValue(aROCInfo.theFEWName_, row, FEWName);
		TableBase::activeTableView_->getValue(aROCInfo.theFEWChannel_, row, FEWChannel);
		TableBase::activeTableView_->getValue(
		    aROCInfo.theFEWROCAddress_, row, FEWROCAddress);
		TableBase::activeTableView_->getValue(aROCInfo.theFERName_, row, FERName);
		TableBase::activeTableView_->getValue(aROCInfo.theFERChannel_, row, FEWChannel);
		TableBase::activeTableView_->getValue(
		    aROCInfo.theFERROCAddress_, row, FERROCAddress);
	}
}

//==============================================================================
std::vector<std::string> ROCToFEConfiguration::getFEWROCsList(std::string fECNumber) const
{
	std::string              tmpDetectorID;
	std::string              tmpFEWName;
	std::vector<std::string> list;
	for(unsigned int row = 0; row < TableBase::activeTableView_->getNumberOfRows(); row++)
	{
		TableBase::activeTableView_->getValue(tmpFEWName, row, FEWName);
		if(tmpFEWName == fECNumber)
		{
			TableBase::activeTableView_->getValue(tmpDetectorID, row, DetectorID);
			list.push_back(tmpDetectorID);
		}
	}
	return list;
}

//==============================================================================
std::vector<std::string> ROCToFEConfiguration::getFERROCsList(std::string fEDNumber) const
{
	std::string              tmpDetectorID;
	std::string              tmpFERName;
	std::vector<std::string> list;
	for(unsigned int row = 0; row < TableBase::activeTableView_->getNumberOfRows(); row++)
	{
		TableBase::activeTableView_->getValue(tmpFERName, row, FERName);
		if(tmpFERName == fEDNumber)
		{
			TableBase::activeTableView_->getValue(tmpDetectorID, row, DetectorID);
			list.push_back(tmpDetectorID);
		}
	}
	return list;
}

//==============================================================================
unsigned int ROCToFEConfiguration::getFEWChannel(const std::string& rOCName) const
{
	return nameToInfoMap_.find(rOCName)->second.theFEWChannel_;
}

//==============================================================================
unsigned int ROCToFEConfiguration::getFEWROCAddress(const std::string& rOCName) const
{
	return nameToInfoMap_.find(rOCName)->second.theFEWROCAddress_;
}

//==============================================================================
unsigned int ROCToFEConfiguration::getFERChannel(const std::string& rOCName) const
{
	return nameToInfoMap_.find(rOCName)->second.theFERChannel_;
}

DEFINE_OTS_CONFIGURATION(ROCToFEConfiguration)
