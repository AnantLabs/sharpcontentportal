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
using System.Xml;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Modules.Definitions;

namespace SharpContent.Modules.Admin.ResourceInstaller
{
    /// <summary>
    /// The PaCsnAdapter_V3 extends PaCsnAdapter_V2 to support V3 Modules
    /// </summary>
    /// <remarks>
    /// </remarks>
    public class PaCsnAdapter_V3 : PaCsnAdapter_V2
    {
        public PaCsnAdapter_V3(PaInstallInfo InstallerInfo)
            : base(InstallerInfo)
        {
        }

        protected override PaFolder GetFolderAttributesFromNode(XmlElement FolderElement)
        {
            // call the V2 implementation to load the values
            PaFolder folder = base.GetFolderAttributesFromNode(FolderElement);

            // V3 .SCP file format adds the optional businesscontrollerclass node to the folder node element
            XmlElement businessControllerElement = (XmlElement)FolderElement.SelectSingleNode("businesscontrollerclass");
            if (businessControllerElement != null)
            {
                folder.BusinessControllerClass = businessControllerElement.InnerText.Trim();
            }

            // V3 .SCP file format adds the optional friendlyname/foldername/modulename nodes to the folder node element
            //For these new nodes the defaults are as follows
            // <friendlyname>, <name>
            // <foldernamee>, <name>, "MyModule"
            // <modulename>, <friendlyname>, <name>
            XmlElement friendlynameElement = (XmlElement)FolderElement.SelectSingleNode("friendlyname");
            if (friendlynameElement != null)
            {
                folder.FriendlyName = friendlynameElement.InnerText.Trim();
                folder.ModuleName = friendlynameElement.InnerText.Trim();
            }

            XmlElement foldernameElement = (XmlElement)FolderElement.SelectSingleNode("foldername");
            if (foldernameElement != null)
            {
                folder.FolderName = foldernameElement.InnerText.Trim();
            }
            if (folder.FolderName == "")
            {
                folder.FolderName = "MyModule";
            }

            XmlElement modulenameElement = (XmlElement)FolderElement.SelectSingleNode("modulename");
            if (modulenameElement != null)
            {
                folder.ModuleName = modulenameElement.InnerText.Trim();
            }

            // V4.3.6 .SCP file format adds the optional compatibleversions node to the folder node element
            XmlElement compatibleVersionsElement = (XmlElement)(FolderElement.SelectSingleNode("compatibleversions"));
            if (compatibleVersionsElement != null)
            {
                folder.CompatibleVersions = compatibleVersionsElement.InnerText.Trim();
            }

            // V4.4.0 .SCP file format adds the optional supportsprobingprivatepath node to the folder node element
            XmlElement supportsProbingPrivatePath = (XmlElement)(FolderElement.SelectSingleNode("supportsprobingprivatepath"));
            if (supportsProbingPrivatePath != null)
            {
                folder.SupportsProbingPrivatePath = Convert.ToBoolean(supportsProbingPrivatePath.InnerText.Trim());
            }

            return folder;
        }

        protected override ModuleControlInfo GetModuleControlFromNode(string Foldername, int TempModuleID, XmlElement ModuleControl)
        {
            // Version 3 .SCP file format adds the helpurl node to the controls/control node element
            ModuleControlInfo ModControl = base.GetModuleControlFromNode(Foldername, TempModuleID, ModuleControl);
            if (ModControl != null)
            {
                XmlElement helpElement = (XmlElement)ModuleControl.SelectSingleNode("helpurl");
                if (helpElement != null)
                {
                    ModControl.HelpURL = helpElement.InnerText.Trim();
                }
            }
            return ModControl;
        }

        protected override ModuleDefinitionInfo GetModuleFromNode(int TempModuleDefinitionID, PaFolder Folder, XmlElement SCPModule)
        {
            ModuleDefinitionInfo ModuleDef = base.GetModuleFromNode(TempModuleDefinitionID, Folder, SCPModule);

            if (ModuleDef != null)
            {
                XmlElement cacheElement = (XmlElement)SCPModule.SelectSingleNode("cachetime");
                if (cacheElement != null)
                {
                    ModuleDef.DefaultCacheTime = Convert.ToInt32(cacheElement.InnerText.Trim());
                }
            }

            return ModuleDef;
        }

        protected override void LogValidFormat()
        {
            InstallerInfo.Log.AddInfo(string.Format(SCP_Valid, "3.0"));
        }
    }
}