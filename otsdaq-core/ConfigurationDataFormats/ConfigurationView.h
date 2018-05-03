#ifndef _ots_ConfigurationView_h_
#define _ots_ConfigurationView_h_

#include "otsdaq-core/ConfigurationDataFormats/ViewColumnInfo.h"
#include "otsdaq-core/MessageFacility/MessageFacility.h"
#include "otsdaq-core/Macros/CoutMacros.h"
#include "otsdaq-core/Macros/StringMacros.h"
#include "otsdaq-core/ConfigurationDataFormats/ConfigurationVersion.h"

#include <iostream>
#include <vector>
#include <cassert>
#include <stdlib.h>
#include <time.h>       /* time_t, time, ctime */

namespace ots
{

class ConfigurationView
{

public:

	static const unsigned int INVALID;
	typedef std::vector<std::vector<std::string> > DataView;
	typedef DataView::iterator                     iterator;
	typedef DataView::const_iterator               const_iterator;

	ConfigurationView							(const std::string &name="");
	virtual ~ConfigurationView					(void);
	ConfigurationView& 	copy					(const ConfigurationView &src, ConfigurationVersion destinationVersion, const std::string &author);


	void 	init(void);



	//==============================================================================
	template<class T>
	unsigned int findRow(unsigned int col, const T& value,
			unsigned int offsetRow=0) const
	{
		std::istringstream s(value);
		return findRow(col,s.str(),offsetRow);
	}
	unsigned int findRow			(unsigned int col, const std::string&  value, unsigned int offsetRow=0) const;
	//==============================================================================
	template<class T>
	unsigned int findRowInGroup(unsigned int col, const T& value,
			const std::string &groupId, const std::string &childLinkIndex, unsigned int offsetRow=0) const
	{
		std::istringstream s(value);
		return findRowInGroup(col,s.str(),groupId,childLinkIndex,offsetRow);
	}
	unsigned int findRowInGroup		(unsigned int col, const std::string &value, const std::string &groupId, const std::string &childLinkIndex, unsigned int offsetRow=0) const;
	unsigned int findCol			(const std::string &name) const;
	unsigned int findColByType		(const std::string &type, int startingCol = 0) const;

	//Getters
	const std::string& 				getUniqueStorageIdentifier 	(void) const;
	const std::string& 				getTableName      			(void) const;
	const ConfigurationVersion& 	getVersion        			(void) const;
	const std::string&				getComment        			(void) const;
	const std::string&				getAuthor         			(void) const;
	const time_t& 					getCreationTime   			(void) const;
	const time_t& 					getLastAccessTime  			(void) const;
	const bool&						getLooseColumnMatching 		(void) const;
	const unsigned int				getDataColumnSize	 		(void) const;
	const unsigned int&				getSourceColumnMismatch		(void) const;
	const unsigned int&				getSourceColumnMissing		(void) const;
	const std::set<std::string>&	getSourceColumnNames		(void) const;
	std::set<std::string>			getColumnNames				(void) const;
	std::set<std::string>			getColumnStorageNames		(void) const;
	std::vector<std::string>		getDefaultRowValues			(void) const;

	unsigned int 					getNumberOfRows   			(void) const;
	unsigned int 					getNumberOfColumns			(void) const;
	const unsigned int 			    getColUID					(void) const;
	const unsigned int 			    getColStatus				(void) const;

	//Note: Group link handling should be done in this ConfigurationView class
	//	only by using isEntryInGroup ...
	//	This is so that multiple group handling is consistent
private:
	bool			 			    isEntryInGroupCol			(const unsigned int& row, const unsigned int& groupCol, const std::string& groupNeedle, std::set<std::string>* groupIDList = 0) const;
public:
	//std::set<std::string /*GroupId*/>
	std::set<std::string>			getSetOfGroupIDs			(const std::string& childLinkIndex, unsigned int row = -1) const;
	bool			 			    isEntryInGroup				(const unsigned int& row, const std::string& childLinkIndex, const std::string& groupNeedle) const;
	const bool	 					getChildLink				(const unsigned int& col, bool& isGroup, std::pair<unsigned int /*link col*/, unsigned int /*link id col*/>& linkPair) const;
	const unsigned int 			    getColLinkGroupID			(const std::string& childLinkIndex) const;
	void			 			    addRowToGroup				(const unsigned int& row, const unsigned int& col, const std::string& groupID);//, const std::string& colDefault);
	bool			 			    removeRowFromGroup			(const unsigned int& row, const unsigned int& col, const std::string& groupID, bool deleteRowIfNoGroupLeft=false);

	//==============================================================================
	//Philosophy: force type validation by passing value to fill by reference..
	//	don't allow string to be returned.. (at least not easily)
	//Since there is no environmental variable that can just be a number they will all be converted no matter what.
	template<class T>
	void getValue(T& value, unsigned int row, unsigned int col, bool doConvertEnvironmentVariables=true) const
	{
		if(!(col < columnsInfo_.size() && row < getNumberOfRows()))
		{
			__SS__ << "Invalid row col requested" << std::endl;
			__COUT_ERR__ << "\n" << ss.str();
			throw std::runtime_error(ss.str());
		}

		value = validateValueForColumn<T>(theDataView_[row][col],col,doConvertEnvironmentVariables);
	}
	//special version of getValue for string type
	//	Note: necessary because types of std::basic_string<char> cause compiler problems if no string specific function
	void 		getValue(std::string& value, unsigned int row, unsigned int col, bool doConvertEnvironmentVariables=true) const;

	//==============================================================================
	//validateValueForColumn
	//	validates value against data rules for specified column.
	//	throws exception if invalid.
	//
	//	on success returns what the value would be for get value
	template<class T>
	T validateValueForColumn(const std::string& value, unsigned int col,
			bool doConvertEnvironmentVariables=true) const
	{
		if(col >= columnsInfo_.size())
		{
			__SS__ << "Invalid col requested" << std::endl;
			__COUT_ERR__ << "\n" << ss.str();
			throw std::runtime_error(ss.str());
		}

		T retValue;

		try
		{
			if(columnsInfo_[col].getDataType() == ViewColumnInfo::DATATYPE_NUMBER) //handle numbers
			{
				std::string data = doConvertEnvironmentVariables?StringMacros::convertEnvironmentVariables(value):
						value;

				if(!StringMacros::isNumber(data))
				{
					__SS__ << (data + " is not a number!") << std::endl;
					__COUT__ << "\n" << ss.str();
					throw std::runtime_error(ss.str());
				}

				if(typeid(double) == typeid(retValue))
					retValue = strtod(data.c_str(),0);
				else if(typeid(float) == typeid(retValue))
					retValue = strtof(data.c_str(),0);
				else if(data.size() > 2 && data[1] == 'x') //assume hex value
					retValue = strtol(data.c_str(),0,16);
				else if(data.size() > 1 && data[0] == 'b') //assume binary value
					retValue = strtol(data.substr(1).c_str(),0,2); //skip first 'b' character
				else
					retValue = strtol(data.c_str(),0,10);

				return retValue;
			}
			else if(columnsInfo_[col].getType() == ViewColumnInfo::TYPE_FIXED_CHOICE_DATA &&
					columnsInfo_[col].getDataType() == ViewColumnInfo::DATATYPE_STRING &&
					(typeid(int) == typeid(retValue) ||
							typeid(unsigned int) == typeid(retValue)))
			{
				//this case is for if fixed choice type but int is requested
				//	then return index in fixed choice list
				//	(always consider DEFAULT as index 0)
				//throw error if no match

				if(value == ViewColumnInfo::DATATYPE_STRING_DEFAULT)
					retValue = 0;
				else
				{
					std::vector<std::string> choices = columnsInfo_[col].getDataChoices();

					//				for(const auto& choice: choices)
					//					__COUT__ << "choice " << choice << __E__;

					//consider arbitrary bool
					bool skipOne = (choices.size() &&
							choices[0].find("arbitraryBool=") == 0);

					for(retValue=1 + (skipOne?1:0);retValue-1<(T)choices.size();++retValue)
						if(value == choices[retValue-1])
							return retValue - (skipOne?1:0); //value has been set to selected choice index, so return

					__SS__ << "\tInvalid value for column data type: " << columnsInfo_[col].getDataType()
								<< " in configuration " << tableName_
								<< " at column=" << columnsInfo_[col].getName()
								<< " for getValue with type '" << StringMacros::demangleTypeName(typeid(retValue).name())
								<< ".'"
								<< "Attempting to get index of '" << value
								<< " in fixed choice array, but was not found in array. "
								<< "Here are the valid choices:\n";
					ss << "\t" << ViewColumnInfo::DATATYPE_STRING_DEFAULT << "\n";
					for(const auto &choice:choices)
						ss << "\t" << choice << "\n";
					__COUT__ << "\n" << ss.str();
					throw std::runtime_error(ss.str());
				}

				return retValue;
			}
			else if(columnsInfo_[col].getDataType() == ViewColumnInfo::DATATYPE_STRING &&
					typeid(bool) == typeid(retValue)) //handle bool
			{
				if(columnsInfo_[col].getType() == ViewColumnInfo::TYPE_ON_OFF)
					retValue = (value == ViewColumnInfo::TYPE_VALUE_ON) ? true:false;
				else if(columnsInfo_[col].getType() == ViewColumnInfo::TYPE_TRUE_FALSE)
					retValue = (value == ViewColumnInfo::TYPE_VALUE_TRUE) ? true:false;
				else if(columnsInfo_[col].getType() == ViewColumnInfo::TYPE_YES_NO)
					retValue = (value == ViewColumnInfo::TYPE_VALUE_YES) ? true:false;
				else if(value.length() && value[0] == '1') //for converting pure string types
					retValue = true;
				else if(value.length() && value[0] == '0') //for converting pure string types
					retValue = false;
				else
				{
					__SS__ << "Invalid boolean value encountered: " << value << __E__;
					__SS_THROW__;
				}

				return retValue;
			}
			else if(columnsInfo_[col].getDataType() == ViewColumnInfo::DATATYPE_STRING &&
					typeid(std::string) != typeid(retValue))
			{
				return StringMacros::validateValueForDefaultStringDataType<T>(value,doConvertEnvironmentVariables);
			}

			//if here, then there was a problem
			throw std::runtime_error("Error.");
		}
		catch(const std::runtime_error& e)
		{
			__SS__ << "\tUnrecognized column data type: " << columnsInfo_[col].getDataType()
				<< " and column type: " << columnsInfo_[col].getType()
				<< ", in configuration " << tableName_
				<< " at column=" << columnsInfo_[col].getName()
				<< " for getValue with type '" << StringMacros::demangleTypeName(typeid(retValue).name())
				<< "'" << std::endl;

			if(columnsInfo_[col].getType() == ViewColumnInfo::TYPE_FIXED_CHOICE_DATA)
				ss << "For column type " << ViewColumnInfo::TYPE_FIXED_CHOICE_DATA
				<< " the only valid numeric types are 'int' and 'unsigned int.'" << __E__;

			ss << e.what() << __E__;
			throw std::runtime_error(ss.str());
		}
	} // end validateValueForColumn()
	//special version of getValue for string type
	//	Note: necessary because types of std::basic_string<char> cause compiler problems if no string specific function
	std::string validateValueForColumn(const std::string& value, unsigned int col, bool convertEnvironmentVariables=true) const;

	std::string getValueAsString(unsigned int row, unsigned int col, bool convertEnvironmentVariables=true) const;
	std::string getEscapedValueAsString(unsigned int row, unsigned int col, bool convertEnvironmentVariables=true) const;
	bool		isURIEncodedCommentTheSame(const std::string &comment) const;

	const DataView&                		getDataView    (void) const;
	const std::vector<ViewColumnInfo>& 	getColumnsInfo (void) const;
	std::vector<ViewColumnInfo>* 		getColumnsInfoP(void);
	const ViewColumnInfo&              	getColumnInfo  (unsigned int column) const;

	//Setters

	void setUniqueStorageIdentifier (const std::string &storageUID	);
	void setTableName    			(const std::string &name 		);
	void setComment 				(const std::string &comment		);
	void setURIEncodedComment 		(const std::string &uriComment	);
	void setAuthor  				(const std::string &author 		);
	void setCreationTime  			(time_t      t				);
	void setLastAccessTime 			(time_t      t = time(0)  	);
	void setLooseColumnMatching 	(bool 	 	 setValue		);

	//==============================================================================
	template<class T>
	void setVersion 		(const T 	&version)
	{
		version_ = ConfigurationVersion(version);
	}


	//==============================================================================
	//These two methods check for basic type consistency
	template<class T>
	void setValue(const T &value, unsigned int row, unsigned int col)
	{
		if(!(col < columnsInfo_.size() && row < getNumberOfRows()))
		{
			__SS__ << "Invalid row (" << row << ") col (" << col << ") requested!" << std::endl;
			throw std::runtime_error(ss.str());
		}

		if(columnsInfo_[col].getDataType() == ViewColumnInfo::DATATYPE_NUMBER)
		{
			std::stringstream ss;
			ss << value;
			theDataView_[row][col] = ss.str();
		}
		else if(columnsInfo_[col].getDataType() == ViewColumnInfo::DATATYPE_TIME &&
				typeid(time_t) == typeid(value))
		{
			//save DATATYPE_TIME as unix timestamp, but get as nice string
			std::stringstream ss;
			ss << value;
			theDataView_[row][col] = ss.str();
		}
		else
		{
			__SS__ << "\tUnrecognized view data type: " << columnsInfo_[col].getDataType()
					<< " in configuration " << tableName_
					<< " at column=" << columnsInfo_[col].getName()
					<< " for setValue with type '" << StringMacros::demangleTypeName(typeid(value).name())
					<< "'" << std::endl;
			throw std::runtime_error(ss.str());
		}
	}
	void 				setValue					(const std::string &value, unsigned int row, unsigned int col);
	void 				setValue					(const char *value, unsigned int row, unsigned int col);

	//Careful: The setValueAsString method is used to set the value without any consistency check with the data type
	void 				setValueAsString			(const std::string &value, unsigned int row, unsigned int col);

	//==============================================================================
	void				resizeDataView				(unsigned int nRows, unsigned int nCols);
	int					addRow        				(const std::string &author = "", bool incrementUniqueData = false, std::string baseNameAutoUID = ""); //returns index of added row, always is last row
	void 				deleteRow     				(int r);

	//Lore did not like this.. wants special access through separate Supervisor for "Database Management" int		addColumn(std::string name, std::string viewName, std::string viewType); //returns index of added column, always is last column unless


	iterator       		begin						(void)       {return theDataView_.begin();}
	iterator       		end  						(void)       {return theDataView_.end();}
	const_iterator 		begin						(void) const {return theDataView_.begin();}
	const_iterator 		end  						(void) const {return theDataView_.end();}
	void           		reset						(void);
	void           		print						(std::ostream &out = std::cout) const;
	void           		printJSON					(std::ostream &out = std::cout) const;
	int            		fillFromJSON				(const std::string &json);
	int            		fillFromCSV					(const std::string &data, const int &dataOffset = 0, const std::string &author = "") throw(std::runtime_error);
	bool				setURIEncodedValue			(const std::string &value, const unsigned int &row, const unsigned int &col, const std::string &author = "");


private:
	const unsigned int 	getOrInitColUID				(void);
	const unsigned int 	getOrInitColStatus			(void);

	ConfigurationView& 	operator=		   			(const ConfigurationView src); //operator= is purposely undefined and private (DO NOT USE IT!) - should use ConfigurationView::copy()

	std::string							uniqueStorageIdentifier_; //starts empty "", used to implement re-writable views ("temporary views") in artdaq db
	std::string                 		tableName_   	;	//View name (extensionTableName in xml)
	ConfigurationVersion        		version_     	;	//Configuration version
	std::string                 		comment_     	;	//Configuration version comment
	std::string                			author_      	;
	time_t		                		creationTime_	;	//used more like "construction"(constructor) time
	time_t		                		lastAccessTime_ ;	//last time the ConfigurationInterface:get() retrieved this view
	unsigned int						colUID_, colStatus_; //special column pointers
	std::map<std::string, unsigned int>	colLinkGroupIDs_; //map from child link index to column

	bool								fillWithLooseColumnMatching_;
	unsigned int						sourceColumnMismatchCount_, sourceColumnMissingCount_;
	std::set<std::string>				sourceColumnNames_;

	std::vector<ViewColumnInfo> 		columnsInfo_ ;
	DataView                    		theDataView_ ;
};
}



#endif
