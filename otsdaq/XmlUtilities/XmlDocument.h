#ifndef ots_XmlDocument_h
#define ots_XmlDocument_h

#include <dirent.h>   
#include <map> 
#include <sys/stat.h> 
#include <sys/types.h>
#include <sstream>
#include <stdio.h>
#include <string.h>
#include <string>
#include <unistd.h>
#include <vector>

#include <xercesc/dom/DOM.hpp>
#include <xercesc/dom/DOMElement.hpp>
#include <xercesc/framework/LocalFileFormatTarget.hpp>
#include <xercesc/framework/StdOutFormatTarget.hpp>
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/util/OutOfMemoryException.hpp>
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/XMLString.hpp>

#if defined(XERCES_NEW_IOSTREAMS)
#include <iostream>
#else
#include <iostream.h>
#endif

 //===============================================================================================================
namespace ots
{
 class XmlDocument
 {
  //---------------------------------------------------------------------------------------------------------------
  public:
                               XmlDocument            (                             std::string rootName = "ROOT");
                               XmlDocument            (const                        XmlDocument& doc             );
                               XmlDocument & operator=(const                        XmlDocument& doc             );
                              ~XmlDocument            (void                                                      );

   xercesc::DOMElement       * addTextElementToParent (std::string                  childName                   ,
                                                       std::string                  childText                   ,
                                                       xercesc::DOMElement        * parent                       );
   xercesc::DOMElement       * addTextElementToParent (std::string                  childName                   ,
                                                       std::string                  childText                   ,
                                                       std::string                  parentName                  ,
                                                       unsigned int                 parentIndex = 0              );
   void saveXmlDocument                               (std::string filePath);
   void recursiveRemoveChild                          (xercesc::DOMElement        * childEl                     ,    
                                                       xercesc::DOMElement        * parentEl                     );  
   bool loadXmlDocument                               (std::string                  filePath                     );
   void outputXmlDocument                             (std::ostringstream         * out, 
                                                       bool                         dispStdOut = false           );
   void                        makeDirectoryBinaryTree(const char                 * name                        ,
                                                       std::string                  rootPath                    ,
                                                       int                          indent                      ,
                                                       xercesc::DOMElement        * anchorNode                   );
   xercesc::DOMElement       * populateBinaryTreeNode (xercesc::DOMElement        * anchorNode                  ,  
                                                       std::string                  name                        ,  
                                                       int                          indent                      ,
                                                       std::string                  fullPath                    ,
                                                       std::string                  isLeaf                       );
   void setDocument                                   (xercesc::DOMDocument       * doc                          );
   void                        setDarioStyle          (bool                         darioStyle                   );
   void                        setRootPath            (std::string                  rootPath                     ) {fRootPath_ = rootPath;}
  //---------------------------------------------------------------------------------------------------------------
  protected:
   void copyDocument                                  (const xercesc::DOMDocument * toCopy                      , 
                                                             xercesc::DOMDocument * copy                         );
   void recursiveElementCopy                          (const xercesc::DOMElement  * toCopy                      ,
                                                             xercesc::DOMElement  * copy                         );
   void initDocument                                  (void);
   void initPlatform                                  (void);
   void terminatePlatform                             (void);
   void recursiveOutputXmlDocument                    (xercesc::DOMElement        * currEl                      ,
                                                       std::ostringstream         * out                         ,
                                                       bool                         dispStdOut = false          ,
                                                       std::string                  tabStr     = ""              );
   std::string escapeString                           (std::string                  inString                    , 
                                                       bool                         allowWhiteSpace = false      );
   
   xercesc::DOMImplementation           * theImplementation_;
   xercesc::DOMDocument                 * theDocument_      ;
   xercesc::DOMElement                  * rootElement_      ;
   const std::string                      rootTagName_      ;

   xercesc::DOMDocument                 * doc               ;
   xercesc::DOMElement                  * rootElem          ;
   DIR                                  * dir               ;
   struct  dirent                       * entry             ;
   int                                    lastIndent        ;
   int                                    errorCode         ;
   int                                    level             ;
   std::string                            fullPath          ;
   std::string                            fullFPath         ;
   std::stringstream                      ss_               ;
   std::map<int, xercesc::DOMElement *>   theNodes          ;
   xercesc::DOMImplementation           * impl              ;
   xercesc::DOMLSSerializer             * pSerializer       ;
   xercesc::DOMConfiguration            * pDomConfiguration ;
   bool                                   darioXMLStyle_    ;
   
   std::string                            fSystemPath_      ;
   std::string                            fRootPath_        ;
   std::string                            foldersPath_      ;
   std::string                            simpleNamePath_   ;

 };
}  // namespace ots

#endif  // ots_XmlDocument_h
