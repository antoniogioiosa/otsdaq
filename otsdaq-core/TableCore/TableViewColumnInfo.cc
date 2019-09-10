#include "otsdaq-core/TableCore/TableViewColumnInfo.h"

#include "otsdaq-core/Macros/CoutMacros.h"
#include "otsdaq-core/Macros/StringMacros.h"

#include <iostream>
#include <sstream>
#include <stdexcept>

#include "otsdaq-core/TableCore/TableView.h"

using namespace ots;

// NOTE: Do NOT put '-' in static const TYPEs because it will mess up javascript handling
// in the web gui
const std::string TableViewColumnInfo::TYPE_UID = "UID";

const std::string TableViewColumnInfo::TYPE_DATA              = "Data";
const std::string TableViewColumnInfo::TYPE_UNIQUE_DATA       = "UniqueData";
const std::string TableViewColumnInfo::TYPE_UNIQUE_GROUP_DATA = "UniqueGroupData";
const std::string TableViewColumnInfo::TYPE_MULTILINE_DATA    = "MultilineData";
const std::string TableViewColumnInfo::TYPE_FIXED_CHOICE_DATA = "FixedChoiceData";
const std::string TableViewColumnInfo::TYPE_BITMAP_DATA       = "BitMap";

const std::string TableViewColumnInfo::TYPE_ON_OFF     = "OnOff";
const std::string TableViewColumnInfo::TYPE_TRUE_FALSE = "TrueFalse";
const std::string TableViewColumnInfo::TYPE_YES_NO     = "YesNo";

const std::string TableViewColumnInfo::TYPE_START_CHILD_LINK     = "ChildLink";
const std::string TableViewColumnInfo::TYPE_START_CHILD_LINK_UID = "ChildLinkUID";
const std::string TableViewColumnInfo::TYPE_START_CHILD_LINK_GROUP_ID =
    "ChildLinkGroupID";
const std::string TableViewColumnInfo::TYPE_START_GROUP_ID = "GroupID";
const std::string TableViewColumnInfo::TYPE_COMMENT        = "Comment";
const std::string TableViewColumnInfo::TYPE_AUTHOR         = "Author";
const std::string TableViewColumnInfo::TYPE_TIMESTAMP      = "Timestamp";
// NOTE: Do NOT put '-' in static const TYPEs because it will mess up javascript handling
// in the web gui

const std::string TableViewColumnInfo::DATATYPE_NUMBER = "NUMBER";
const std::string TableViewColumnInfo::DATATYPE_STRING = "VARCHAR2";
const std::string TableViewColumnInfo::DATATYPE_TIME   = "TIMESTAMP WITH TIMEZONE";

const std::string TableViewColumnInfo::TYPE_VALUE_YES   = "Yes";
const std::string TableViewColumnInfo::TYPE_VALUE_NO    = "No";
const std::string TableViewColumnInfo::TYPE_VALUE_TRUE  = "True";
const std::string TableViewColumnInfo::TYPE_VALUE_FALSE = "False";
const std::string TableViewColumnInfo::TYPE_VALUE_ON    = "On";
const std::string TableViewColumnInfo::TYPE_VALUE_OFF   = "Off";

const std::string TableViewColumnInfo::DATATYPE_STRING_DEFAULT  = "DEFAULT";
const std::string TableViewColumnInfo::DATATYPE_COMMENT_DEFAULT = "No Comment";
const std::string TableViewColumnInfo::DATATYPE_BOOL_DEFAULT    = "0";
const std::string TableViewColumnInfo::DATATYPE_NUMBER_DEFAULT  = "0";
const std::string TableViewColumnInfo::DATATYPE_TIME_DEFAULT    = "0";
const std::string TableViewColumnInfo::DATATYPE_LINK_DEFAULT    = "NO_LINK";

const std::string TableViewColumnInfo::COL_NAME_STATUS   = "Status";
const std::string TableViewColumnInfo::COL_NAME_ENABLED  = "Enabled";
const std::string TableViewColumnInfo::COL_NAME_PRIORITY = "Priority";
const std::string TableViewColumnInfo::COL_NAME_COMMENT  = "CommentDescription";

//==============================================================================
// TableViewColumnInfo
// if(capturedExceptionString) *capturedExceptionString = ""; //indicates no error found
// if(!capturedExceptionString) then exception is thrown on error
TableViewColumnInfo::TableViewColumnInfo(const std::string& type,
                                         const std::string& name,
                                         const std::string& storageName,
                                         const std::string& dataType,
                                         const std::string& dataChoicesCSV,
                                         std::string*       capturedExceptionString)
    : type_(type)
    , name_(name)
    , storageName_(storageName)
    , dataType_(dataType)
    , bitMapInfoP_(0)
{
	// verify type
	if((type_ != TYPE_UID) && (type_ != TYPE_DATA) && (type_ != TYPE_UNIQUE_DATA) &&
	   (type_ != TYPE_UNIQUE_GROUP_DATA) && (type_ != TYPE_MULTILINE_DATA) &&
	   (type_ != TYPE_FIXED_CHOICE_DATA) && (type_ != TYPE_BITMAP_DATA) &&
	   (type_ != TYPE_ON_OFF) && (type_ != TYPE_TRUE_FALSE) && (type_ != TYPE_YES_NO) &&
	   (type_ != TYPE_COMMENT) && (type_ != TYPE_AUTHOR) && (type_ != TYPE_TIMESTAMP) &&
	   !isChildLink() && !isChildLinkUID() && !isChildLinkGroupID() && !isGroupID())
	{
		__SS__ << "The type for column " << name_ << " is " << type_
		       << ", while the only accepted types are: " << TYPE_DATA << " "
		       << TYPE_UNIQUE_DATA << " " << TYPE_UNIQUE_GROUP_DATA << " "
		       << TYPE_MULTILINE_DATA << " " << TYPE_FIXED_CHOICE_DATA << " " << TYPE_UID
		       << " " << TYPE_ON_OFF << " " << TYPE_TRUE_FALSE << " " << TYPE_YES_NO
		       << " " << TYPE_START_CHILD_LINK << "-* " << TYPE_START_CHILD_LINK_UID
		       << "-* " << TYPE_START_CHILD_LINK_GROUP_ID << "-* " << TYPE_START_GROUP_ID
		       << "-* " << std::endl;
		if(capturedExceptionString)
			*capturedExceptionString = ss.str();
		else
			__SS_THROW__;
	}
	else if(capturedExceptionString)
		*capturedExceptionString = "";  // indicates no error found

	// enforce that type only
	// allows letters, numbers, dash, underscore
	for(unsigned int i = 0; i < type_.size(); ++i)
		if(!((type_[i] >= 'A' && type_[i] <= 'Z') ||
		     (type_[i] >= 'a' && type_[i] <= 'z') ||
		     (type_[i] >= '0' && type_[i] <= '9') ||
		     (type_[i] == '-' || type_[i] <= '_' || type_[i] <= '.')))
		{
			__SS__ << "The data type for column " << name_ << " is '" << type_
			       << "'. Data types must contain only letters, numbers,"
			       << "dashes, underscores, and periods." << std::endl;
			if(capturedExceptionString)
				*capturedExceptionString += ss.str();
			else
				__SS_THROW__;
		}

	// verify data type
	if((dataType_ != DATATYPE_NUMBER) && (dataType_ != DATATYPE_STRING) &&
	   (dataType_ != DATATYPE_TIME))
	{
		__SS__ << "The data type for column " << name_ << " is " << dataType_
		       << ", while the only accepted types are: " << DATATYPE_NUMBER << " "
		       << DATATYPE_STRING << " " << DATATYPE_TIME << std::endl;
		if(capturedExceptionString)
			*capturedExceptionString += ss.str();
		else
			__SS_THROW__;
	}

	if(dataType_.size() == 0)
	{
		__SS__ << "The data type for column " << name_ << " is '" << dataType_
		       << "'. Data types must contain at least 1 character." << std::endl;
		if(capturedExceptionString)
			*capturedExceptionString += ss.str();
		else
			__SS_THROW__;
	}

	// enforce that data type only
	// allows letters, numbers, dash, underscore
	for(unsigned int i = 0; i < dataType_.size(); ++i)
		if(!((dataType_[i] >= 'A' && dataType_[i] <= 'Z') ||
		     (dataType_[i] >= 'a' && dataType_[i] <= 'z') ||
		     (dataType_[i] >= '0' && dataType_[i] <= '9') ||
		     (dataType_[i] == '-' || dataType_[i] <= '_')))
		{
			__SS__ << "The data type for column " << name_ << " is '" << dataType_
			       << "'. Data types must contain only letters, numbers,"
			       << "dashes, and underscores." << std::endl;
			if(capturedExceptionString)
				*capturedExceptionString += ss.str();
			else
				__SS_THROW__;
		}

	if(name_.size() == 0)
	{
		__SS__ << "There is a column named " << name_
		       << "'. Column names must contain at least 1 character." << std::endl;
		if(capturedExceptionString)
			*capturedExceptionString += ss.str();
		else
			__SS_THROW__;
	}

	// enforce that col name only
	// allows letters, numbers, dash, underscore
	for(unsigned int i = 0; i < name_.size(); ++i)
		if(!((name_[i] >= 'A' && name_[i] <= 'Z') ||
		     (name_[i] >= 'a' && name_[i] <= 'z') ||
		     (name_[i] >= '0' && name_[i] <= '9') ||
		     (name_[i] == '-' || name_[i] <= '_')))
		{
			__SS__ << "There is a column named " << name_
			       << "'. Column names must contain only letters, numbers,"
			       << "dashes, and underscores." << std::endl;
			if(capturedExceptionString)
				*capturedExceptionString += ss.str();
			else
				__SS_THROW__;
		}

	if(storageName_.size() == 0)
	{
		__SS__ << "The storage name for column " << name_ << " is '" << storageName_
		       << "'. Storage names must contain at least 1 character." << std::endl;
		if(capturedExceptionString)
			*capturedExceptionString += ss.str();
		else
			__SS_THROW__;
	}

	// enforce that col storage name only
	// allows capital letters, numbers, dash, underscore
	for(unsigned int i = 0; i < storageName_.size(); ++i)
		if(!((storageName_[i] >= 'A' && storageName_[i] <= 'Z') ||
		     (storageName_[i] >= '0' && storageName_[i] <= '9') ||
		     (storageName_[i] == '-' || storageName_[i] <= '_')))
		{
			__SS__ << "The storage name for column " << name_ << " is '" << storageName_
			       << "'. Storage names must contain only capital letters, numbers,"
			       << "dashes, and underscores." << std::endl;
			if(capturedExceptionString)
				*capturedExceptionString += ss.str();
			else
				__SS_THROW__;
		}

	// build data choices vector from URI encoded data
	//__COUT__ << "dataChoicesCSV " << dataChoicesCSV << std::endl;
	{
		std::istringstream f(dataChoicesCSV);
		std::string        s;
		while(getline(f, s, ','))
			dataChoices_.push_back(StringMacros::decodeURIComponent(s));
		// for(const auto &dc: dataChoices_)
		//	__COUT__ << dc << std::endl;
	}

	try
	{
		extractBitMapInfo();
	}
	catch(std::runtime_error& e)
	{
		if(capturedExceptionString)
			*capturedExceptionString += e.what();
		else
			throw;
	}

	//__COUT__ << "dataChoicesCSV " << dataChoicesCSV << std::endl;
}

//==============================================================================
void TableViewColumnInfo::extractBitMapInfo()
{
	// create BitMapInfo if this is a bitmap column
	if(type_ == TYPE_BITMAP_DATA)
	{
		if(bitMapInfoP_)
			delete bitMapInfoP_;
		bitMapInfoP_ = new BitMapInfo();

		// extract bitMapInfo parameters:
		//	must match TableEditor js handling:

		//		[ //types => 0:string, 1:bool (default no),
		//		  //2:bool (default yes), 3:color
		//
		// 0		  0,//"Number of Rows",
		// 1		  0,//"Number of Columns",
		// 2		  0,//"Cell Bit-field Size",
		// 3		  0,//"Min-value Allowed",
		// 4		  0,//"Max-value Allowed",
		// 5		  0,//"Value step-size Allowed",
		// 6		  0,//"Display Aspect H:W",
		// 7		  3,//"Min-value Cell Color",
		// 8		  3,//"Mid-value Cell Color",
		// 9		  3,//"Max-value Cell Color",
		// 10		  3,//"Absolute Min-value Cell Color",
		// 11		  3,//"Absolute Max-value Cell Color",
		// 12		  1,//"Display Rows in Ascending Order",
		// 13		  2,//"Display Columns in Ascending Order",
		// 14		  1,//"Snake Double Rows",
		// 15		  1];//"Snake Double Columns"];

		if(dataChoices_.size() < 16)
		{
			__SS__ << "The Bit-Map data parameters for column " << name_
			       << " should be size 16, but is size " << dataChoices_.size()
			       << ". Bit-Map parameters should be rows, cols, cellBitSize, and min, "
			          "mid, max color."
			       << std::endl;
			__SS_THROW__;
		}

		sscanf(dataChoices_[0].c_str(), "%u", &(bitMapInfoP_->numOfRows_));
		sscanf(dataChoices_[1].c_str(), "%u", &(bitMapInfoP_->numOfColumns_));
		sscanf(dataChoices_[2].c_str(), "%u", &(bitMapInfoP_->cellBitSize_));

		sscanf(dataChoices_[3].c_str(), "%lu", &(bitMapInfoP_->minValue_));
		sscanf(dataChoices_[4].c_str(), "%lu", &(bitMapInfoP_->maxValue_));
		sscanf(dataChoices_[5].c_str(), "%lu", &(bitMapInfoP_->stepValue_));

		bitMapInfoP_->aspectRatio_ = dataChoices_[6];
		bitMapInfoP_->minColor_    = dataChoices_[7];
		bitMapInfoP_->midColor_    = dataChoices_[8];
		bitMapInfoP_->maxColor_    = dataChoices_[9];
		bitMapInfoP_->absMinColor_ = dataChoices_[10];
		bitMapInfoP_->absMaxColor_ = dataChoices_[11];

		bitMapInfoP_->rowsAscending_ = dataChoices_[12] == "Yes" ? 1 : 0;
		bitMapInfoP_->colsAscending_ = dataChoices_[13] == "Yes" ? 1 : 0;
		bitMapInfoP_->snakeRows_     = dataChoices_[14] == "Yes" ? 1 : 0;
		bitMapInfoP_->snakeCols_     = dataChoices_[15] == "Yes" ? 1 : 0;
	}
}

//==============================================================================
// private empty default constructor. Only used by assignment operator.
TableViewColumnInfo::TableViewColumnInfo(void) {}

//==============================================================================
TableViewColumnInfo::TableViewColumnInfo(
    const TableViewColumnInfo& c)  // copy constructor because of bitmap pointer
    : type_(c.type_)
    , name_(c.name_)
    , storageName_(c.storageName_)
    , dataType_(c.dataType_)
    , dataChoices_(c.dataChoices_)
    , bitMapInfoP_(0)
{
	// extract bitmap info if necessary
	extractBitMapInfo();
}

//==============================================================================
TableViewColumnInfo& TableViewColumnInfo::operator=(
    const TableViewColumnInfo& c)  // assignment operator because of bitmap pointer
{
	TableViewColumnInfo* retColInfo = new TableViewColumnInfo();
	retColInfo->type_               = c.type_;
	retColInfo->name_               = c.name_;
	retColInfo->storageName_        = c.storageName_;
	retColInfo->dataType_           = c.dataType_;
	retColInfo->dataChoices_        = c.dataChoices_;
	retColInfo->bitMapInfoP_        = 0;

	// extract bitmap info if necessary
	retColInfo->extractBitMapInfo();

	return *retColInfo;
}

//==============================================================================
TableViewColumnInfo::~TableViewColumnInfo(void)
{
	if(bitMapInfoP_)
		delete bitMapInfoP_;
}

//==============================================================================
const std::string& TableViewColumnInfo::getType(void) const { return type_; }

//==============================================================================
const std::string& TableViewColumnInfo::getDefaultValue(void) const
{
	if(getDataType() == TableViewColumnInfo::DATATYPE_STRING)
	{
		if(getType() == TableViewColumnInfo::TYPE_ON_OFF ||
		   getType() == TableViewColumnInfo::TYPE_TRUE_FALSE ||
		   getType() == TableViewColumnInfo::TYPE_YES_NO)
			return (
			    TableViewColumnInfo::DATATYPE_BOOL_DEFAULT);  // default to OFF, NO, FALSE
		else if(isChildLink())
			return (TableViewColumnInfo::DATATYPE_LINK_DEFAULT);
		else if(getType() == TableViewColumnInfo::TYPE_COMMENT)
			return (TableViewColumnInfo::DATATYPE_COMMENT_DEFAULT);
		else
			return (TableViewColumnInfo::DATATYPE_STRING_DEFAULT);
	}
	else if(getDataType() == TableViewColumnInfo::DATATYPE_NUMBER)
		return (TableViewColumnInfo::DATATYPE_NUMBER_DEFAULT);
	else if(getDataType() == TableViewColumnInfo::DATATYPE_TIME)
		return (TableViewColumnInfo::DATATYPE_TIME_DEFAULT);
	else
	{
		__SS__ << "\tUnrecognized View data type: " << getDataType() << std::endl;
		__COUT_ERR__ << "\n" << ss.str();
		__SS_THROW__;
	}
}

//==============================================================================
std::vector<std::string> TableViewColumnInfo::getAllTypesForGUI(void)
{
	std::vector<std::string> all;
	all.push_back(TYPE_DATA);
	all.push_back(TYPE_UNIQUE_DATA);
	all.push_back(TYPE_UNIQUE_GROUP_DATA);
	all.push_back(TYPE_FIXED_CHOICE_DATA);
	all.push_back(TYPE_MULTILINE_DATA);
	all.push_back(TYPE_BITMAP_DATA);
	all.push_back(TYPE_ON_OFF);
	all.push_back(TYPE_TRUE_FALSE);
	all.push_back(TYPE_YES_NO);
	all.push_back(TYPE_START_CHILD_LINK_UID);
	all.push_back(TYPE_START_CHILD_LINK_GROUP_ID);
	all.push_back(TYPE_START_CHILD_LINK);
	all.push_back(TYPE_START_GROUP_ID);
	return all;
}

//==============================================================================
std::vector<std::string> TableViewColumnInfo::getAllDataTypesForGUI(void)
{
	std::vector<std::string> all;
	all.push_back(DATATYPE_STRING);
	all.push_back(DATATYPE_NUMBER);
	all.push_back(DATATYPE_TIME);
	return all;
}

//==============================================================================
// map of datatype,type to default value
std::map<std::pair<std::string, std::string>, std::string>
TableViewColumnInfo::getAllDefaultsForGUI(void)
{
	std::map<std::pair<std::string, std::string>, std::string> all;
	all[std::pair<std::string, std::string>(DATATYPE_NUMBER, "*")] =
	    DATATYPE_NUMBER_DEFAULT;
	all[std::pair<std::string, std::string>(DATATYPE_TIME, "*")] = DATATYPE_TIME_DEFAULT;

	all[std::pair<std::string, std::string>(DATATYPE_STRING, TYPE_ON_OFF)] =
	    DATATYPE_BOOL_DEFAULT;
	all[std::pair<std::string, std::string>(DATATYPE_STRING, TYPE_TRUE_FALSE)] =
	    DATATYPE_BOOL_DEFAULT;
	all[std::pair<std::string, std::string>(DATATYPE_STRING, TYPE_YES_NO)] =
	    DATATYPE_BOOL_DEFAULT;

	all[std::pair<std::string, std::string>(DATATYPE_STRING, TYPE_START_CHILD_LINK)] =
	    DATATYPE_LINK_DEFAULT;
	all[std::pair<std::string, std::string>(DATATYPE_STRING, "*")] =
	    DATATYPE_STRING_DEFAULT;
	return all;
}

//==============================================================================
// isBoolType
const bool TableViewColumnInfo::isBoolType(void) const
{
	return (type_ == TYPE_ON_OFF || type_ == TYPE_TRUE_FALSE || type_ == TYPE_YES_NO);
}  // end isBoolType()

//==============================================================================
// isNumberDataType
const bool TableViewColumnInfo::isNumberDataType(void) const
{
	return (dataType_ == DATATYPE_NUMBER);
}  // end isBoolType()

//==============================================================================
const std::string& TableViewColumnInfo::getName(void) const { return name_; }

//==============================================================================
const std::string& TableViewColumnInfo::getStorageName(void) const
{
	return storageName_;
}

//==============================================================================
const std::string& TableViewColumnInfo::getDataType(void) const { return dataType_; }

//==============================================================================
const std::vector<std::string>& TableViewColumnInfo::getDataChoices(void) const
{
	return dataChoices_;
}

//==============================================================================
// getBitMapInfo
//	uses dataChoices CSV fields if type is TYPE_BITMAP_DATA
const TableViewColumnInfo::BitMapInfo& TableViewColumnInfo::getBitMapInfo(void) const
{
	if(bitMapInfoP_)
		return *bitMapInfoP_;

	// throw error at this point!
	{
		__SS__ << "getBitMapInfo request for non-BitMap column of type: " << getType()
		       << std::endl;
		__COUT_ERR__ << "\n" << ss.str();
		__SS_THROW__;
	}
}

//==============================================================================
// isChildLink
//	note: TYPE_START_CHILD_LINK index may be a subset of UID and GROUP_ID
//	so don't allow alpha character immediately after
const bool TableViewColumnInfo::isChildLink(void) const
{
	return (type_.find(TYPE_START_CHILD_LINK) == 0 &&
	        type_.length() > TYPE_START_CHILD_LINK.length() &&
	        type_[TYPE_START_CHILD_LINK.length()] == '-');
}

//==============================================================================
// isChildLinkUID
//	note: TYPE_START_CHILD_LINK index may be a subset of UID and GROUP_ID
//	so don't allow alpha character immediately after
const bool TableViewColumnInfo::isChildLinkUID(void) const
{
	return (type_.find(TYPE_START_CHILD_LINK_UID) == 0 &&
	        type_.length() > TYPE_START_CHILD_LINK_UID.length() &&
	        type_[TYPE_START_CHILD_LINK_UID.length()] == '-');
}

//==============================================================================
// isChildLinkGroupID
//	note: TYPE_START_CHILD_LINK index may be a subset of UID and GROUP_ID
//	so don't allow alpha character immediately after
const bool TableViewColumnInfo::isChildLinkGroupID(void) const
{
	return (type_.find(TYPE_START_CHILD_LINK_GROUP_ID) == 0 &&
	        type_.length() > TYPE_START_CHILD_LINK_GROUP_ID.length() &&
	        type_[TYPE_START_CHILD_LINK_GROUP_ID.length()] == '-');
}

//==============================================================================
// isGroupID
//	note: TYPE_START_CHILD_LINK index may be a subset of UID and GROUP_ID
//	so don't allow alpha character immediately after in group index
const bool TableViewColumnInfo::isGroupID(void) const
{
	return (type_.find(TYPE_START_GROUP_ID) == 0 &&
	        type_.length() > TYPE_START_GROUP_ID.length() &&
	        type_[TYPE_START_GROUP_ID.length()] == '-');
}

//==============================================================================
// isUID
const bool TableViewColumnInfo::isUID(void) const { return (type_ == TYPE_UID); }

//==============================================================================
// getChildLinkIndex
std::string TableViewColumnInfo::getChildLinkIndex(void) const
{
	// note: +1 to skip '-'
	if(isChildLink())
		return type_.substr(TYPE_START_CHILD_LINK.length() + 1);
	else if(isChildLinkUID())
		return type_.substr(TYPE_START_CHILD_LINK_UID.length() + 1);
	else if(isChildLinkGroupID())
		return type_.substr(TYPE_START_CHILD_LINK_GROUP_ID.length() + 1);
	else if(isGroupID())
		return type_.substr(TYPE_START_GROUP_ID.length() + 1);
	else
	{
		__SS__
		    << ("Requesting a Link Index from a column that is not a child link member!")
		    << std::endl;
		__COUT_ERR__ << ss.str();
		__SS_THROW__;
	}
}
