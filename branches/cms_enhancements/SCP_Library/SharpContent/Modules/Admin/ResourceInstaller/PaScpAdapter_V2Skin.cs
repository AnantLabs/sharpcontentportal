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
using System.ComponentModel;
using System.IO;
using System.Xml;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Modules.Definitions;
using SharpContent.Security;

namespace SharpContent.Modules.Admin.ResourceInstaller
{
    /// <summary>
    /// The PaCsnAdapter_V2Skin extends PaCsnAdapterBase to support V2 Skin Object
    /// </summary>
    /// <remarks>
    /// </remarks>
    public class PaCsnAdapter_V2Skin : PaCsnAdapterBase
    {
        public PaCsnAdapter_V2Skin(PaInstallInfo InstallerInfo)
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
                InstallerInfo.Log.AddInfo(SCP_ValidSkinObject);

                PaFolderCollection Folders = new PaFolderCollection();

                XmlDocument doc = new XmlDocument();
                MemoryStream buffer = new MemoryStream(InstallerInfo.SCPFile.Buffer, false);
                doc.Load(buffer);
                InstallerInfo.Log.AddInfo(XML_Loaded);

                XmlNode SCPRoot = doc.DocumentElement;

                int TempModuleDefinitionID = 0;

                XmlElement FolderElement;
                foreach (XmlElement tempLoopVar_FolderElement in SCPRoot.SelectNodes("folders/folder"))
                {
                    FolderElement = tempLoopVar_FolderElement;
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

                    // in V2 the FriendlyName/FolderName/ModuleName attributes were not supported in the *.SCP file,
                    // so set them to the Folder Name
                    Folder.FriendlyName = Folder.Name;
                    Folder.FolderName = Folder.Name;
                    Folder.ModuleName = Folder.Name;

                    XmlElement resourcefileElement = (XmlElement)FolderElement.SelectSingleNode("resourcefile");
                    if (resourcefileElement != null)
                    {
                        if (resourcefileElement.InnerText.Trim() != "")
                        {
                            Folder.ResourceFile = resourcefileElement.InnerText.Trim();
                            PaFile paRF = (PaFile)InstallerInfo.FileTable[Folder.ResourceFile.ToLower()];
                            if (paRF == null)
                            {
                                InstallerInfo.Log.AddFailure(EXCEPTION_MissingResource + Folder.ResourceFile);
                            }
                            else
                            {
                                paRF.Path = Folder.ResourceFile;
                            }
                        }
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
                            Folder.Files.Add(paf);
                        }
                    }

                    // add SCP file to collection ( if it does not exist already )
                    if (Folder.Files.Contains(InstallerInfo.SCPFile) == false)
                    {
                        Folder.Files.Add(InstallerInfo.SCPFile);
                    }

                    InstallerInfo.Log.AddInfo(MODULES_Loading);
                    XmlElement SCPModule;
                    foreach (XmlElement tempLoopVar_SCPModule in FolderElement.SelectNodes("modules/module"))
                    {
                        SCPModule = tempLoopVar_SCPModule;

                        ModuleDefinitionInfo ModuleDef = new ModuleDefinitionInfo();

                        ModuleDef.TempModuleID = TempModuleDefinitionID;
                        //We need to ensure that admin order is null for "User" modules

                        TempModuleDefinitionID++;

                        Folder.Modules.Add(ModuleDef);

                        InstallerInfo.Log.AddInfo(string.Format(MODULES_ControlInfo, ModuleDef.FriendlyName));
                        XmlElement ModuleControl;
                        foreach (XmlElement tempLoopVar_ModuleControl in SCPModule.SelectNodes("controls/control"))
                        {
                            ModuleControl = tempLoopVar_ModuleControl;
                            ModuleControlInfo ModuleControlDef = new ModuleControlInfo();

                            XmlElement keyElement = (XmlElement)ModuleControl.SelectSingleNode("key");
                            if (keyElement != null)
                            {
                                ModuleControlDef.ControlKey = keyElement.InnerText.Trim();
                            }

                            XmlElement titleElement = (XmlElement)ModuleControl.SelectSingleNode("title");
                            if (titleElement != null)
                            {
                                ModuleControlDef.ControlTitle = titleElement.InnerText.Trim();
                            }

                            try
                            {
                                ModuleControlDef.ControlSrc = Path.Combine("DesktopModules", Path.Combine(Folder.Name, ModuleControl.SelectSingleNode("src").InnerText.Trim()).Replace('\\', '/')).Replace(@"\", "/");
                            }
                            catch (Exception)
                            {
                                throw (new Exception(EXCEPTION_Src));
                            }

                            XmlElement iconFileElement = (XmlElement)ModuleControl.SelectSingleNode("iconfile");
                            if (iconFileElement != null)
                            {
                                ModuleControlDef.IconFile = iconFileElement.InnerText.Trim();
                            }

                            try
                            {
                                ModuleControlDef.ControlType = (SecurityAccessLevel)TypeDescriptor.GetConverter(typeof(SecurityAccessLevel)).ConvertFromString(ModuleControl.SelectSingleNode("type").InnerText.Trim());
                                //ModuleControlDef.ControlType = CType(ModuleControl.SelectSingleNode("type").InnerText.Trim, SecurityAccessLevel)
                            }
                            catch (Exception)
                            {
                                throw (new Exception(EXCEPTION_Type));
                            }

                            XmlElement orderElement = (XmlElement)ModuleControl.SelectSingleNode("vieworder");
                            if (orderElement != null)
                            {
                                ModuleControlDef.ViewOrder = Convert.ToInt32(orderElement.InnerText.Trim());
                            }
                            else
                            {
                                ModuleControlDef.ViewOrder = Null.NullInteger;
                            }

                            //This is a temporary relationship since the ModuleDef has not been saved to the db
                            //it does not have a valid ModuleDefID.  Once it is saved then we can update the
                            //ModuleControlDef with the correct value.
                            ModuleControlDef.ModuleDefID = ModuleDef.TempModuleID;

                            Folder.Controls.Add(ModuleControlDef);
                        }
                    }

                    Folders.Add(Folder);
                }

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