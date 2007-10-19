#region SharpContent License
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by SharpContent Corporation
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions 
// of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
// TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
#endregion
using System;
using System.Collections;
using System.IO;
using System.Xml;
using SharpContent.Entities.Modules.Definitions;

namespace SharpContent.Modules.Admin.ResourceInstaller
{
    /// <summary>
    /// The PaCsnAdapter_V2Provider extends PaCsnAdapterBase to support V2 Providers
    /// </summary>
    /// <remarks>
    /// </remarks>
    public class PaCsnAdapter_V2Provider : PaCsnAdapterBase
    {
        public PaCsnAdapter_V2Provider(PaInstallInfo InstallerInfo)
            : base(InstallerInfo)
        {
        }

        public override PaFolderCollection ReadSCP()
        {
            //This is a very long subroutine and should probably be broken down
            //into a couple of smaller routines.  That would make it easier to
            //maintain.
            InstallerInfo.Log.StartJob(SCP_Reading);

            //Determine if XML conforms to designated schema
            ArrayList SCPErrors = ValidateSCP();
            if (SCPErrors.Count == 0)
            {
                InstallerInfo.Log.AddInfo(string.Format(SCP_Valid, "2.0"));

                PaFolderCollection Folders = new PaFolderCollection();

                XmlDocument doc = new XmlDocument();
                MemoryStream buffer = new MemoryStream(InstallerInfo.SCPFile.Buffer, false);
                doc.Load(buffer);
                InstallerInfo.Log.AddInfo(XML_Loaded);

                //Create an XmlNamespaceManager for resolving namespaces.
                //Dim nsmgr As XmlNamespaceManager = New XmlNamespaceManager(doc.NameTable)
                //nsmgr.AddNamespace("SCP", "urn:ModuleDefinitionSchema")

                XmlNode SCPRoot = doc.DocumentElement;

                XmlElement FolderElement = (XmlElement)SCPRoot.SelectSingleNode("folder");
                //We will process each folder individually.  So we don't need to keep
                //as much in memory.

                //As we loop through each folder, we will save the data
                PaFolder Folder = new PaFolder();

                //The folder/name node is a required node.  If empty, this will throw
                //an exception.
                try
                {
                    Folder.Name = FolderElement.SelectSingleNode("name").InnerText.Trim();
                }
                catch (Exception)
                {
                    throw (new Exception(EXCEPTION_FolderName));
                }

                try
                {
                    Folder.ProviderType = FolderElement.SelectSingleNode("type").InnerText.Trim();
                }
                catch (Exception)
                {
                    throw (new Exception(EXCEPTION_FolderProvider));
                }

                // loading files
                InstallerInfo.Log.AddInfo(FILES_Loading);
                XmlElement file;
                foreach (XmlElement tempLoopVar_file in FolderElement.SelectNodes("files/file"))
                {
                    file = tempLoopVar_file;
                    //The file/name node is a required node.  If empty, this will throw
                    //an exception.
                    string name;
                    try
                    {
                        name = file.SelectSingleNode("name").InnerText.Trim();
                    }
                    catch (Exception)
                    {
                        throw (new Exception(EXCEPTION_FileName));
                    }
                    PaFile paf = (PaFile)InstallerInfo.FileTable[name.ToLower()];
                    if (paf == null)
                    {
                        InstallerInfo.Log.AddFailure(FILE_NotFound + name);
                    }
                    else
                    {
                        //A file path may or may not exist
                        XmlElement pathElement = (XmlElement)file.SelectSingleNode("path");
                        if (!(pathElement == null))
                        {
                            string filepath = pathElement.InnerText.Trim();
                            InstallerInfo.Log.AddInfo(string.Format(FILE_Found, filepath, name));
                            paf.Path = filepath;
                        }
                        else
                        {
                            // This is needed to override any file path which may exist in the zip file
                            paf.Path = "";
                        }
                        Folder.Files.Add(paf);
                    }
                }

                Folders.Add(Folder);

                if (!InstallerInfo.Log.Valid)
                {
                    throw (new Exception(EXCEPTION_LoadFailed));
                }
                InstallerInfo.Log.EndJob(SCP_Success);

                return Folders;
            }
            else
            {
                string err;
                foreach (string tempLoopVar_err in SCPErrors)
                {
                    err = tempLoopVar_err;
                    InstallerInfo.Log.AddFailure(err);
                }
                throw (new Exception(EXCEPTION_Format));
            }
        }

        private ArrayList ValidateSCP()
        {
            //Create New Validator
            ModuleDefinitionValidator ModuleValidator = new ModuleDefinitionValidator();

            //Tell Validator what XML to use
            MemoryStream xmlStream = new MemoryStream(InstallerInfo.SCPFile.Buffer);
            ModuleValidator.Validate(xmlStream);
            return ModuleValidator.Errors;
        }
    }
}