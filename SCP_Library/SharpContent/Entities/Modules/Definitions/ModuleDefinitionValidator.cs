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
using System.IO;
using System.Web;
using System.Xml;
using SharpContent.Common;
using SharpContent.Entities.Portals;
using SharpContent.Services.Localization;

namespace SharpContent.Entities.Modules.Definitions
{
    public class ModuleDefinitionValidator : XmlValidatorBase
    {
        private string GetSCPSchemaPath(Stream xmlStream)
        {
            ModuleDefinitionVersion version = GetModuleDefinitionVersion(xmlStream);
            string schemaPath = "";

            switch (version)
            {
                case ModuleDefinitionVersion.V2:

                    schemaPath = "components\\ResourceInstaller\\ModuleDef_V2.xsd";
                    break;
                case ModuleDefinitionVersion.V3:

                    schemaPath = "components\\ResourceInstaller\\ModuleDef_V3.xsd";
                    break;
                case ModuleDefinitionVersion.V2_Skin:

                    schemaPath = "components\\ResourceInstaller\\ModuleDef_V2Skin.xsd";
                    break;
                case ModuleDefinitionVersion.V2_Provider:

                    schemaPath = "components\\ResourceInstaller\\ModuleDef_V2Provider.xsd";
                    break;
                case ModuleDefinitionVersion.VUnknown:

                    throw (new Exception(GetLocalizedString("EXCEPTION_LoadFailed")));
            }
            return Path.Combine(Globals.ApplicationMapPath, schemaPath);
        }

        private string GetLocalizedString(string key)
        {
            PortalSettings portalSettings = (PortalSettings)HttpContext.Current.Items["PortalSettings"];

            if (portalSettings == null)
            {
                return key;
            }
            else
            {
                return Localization.GetString(key, portalSettings);
            }
        }

        public ModuleDefinitionVersion GetModuleDefinitionVersion(Stream xmlStream)
        {
            xmlStream.Seek(0, SeekOrigin.Begin);
            XmlTextReader xmlReader = new XmlTextReader(xmlStream);
            xmlReader.MoveToContent();

            //This test assumes provides a simple validation 
            if( xmlReader.LocalName.ToLower() == "module" )
            {
                return ModuleDefinitionVersion.V1;
            }
            else if( xmlReader.LocalName.ToLower() == "sharpcontent" )
            {
                if( xmlReader.GetAttribute( "type" ) == "Module" )
                {
                    switch( xmlReader.GetAttribute( "version" ) )
                    {
                        case "2.0":
                            return ModuleDefinitionVersion.V2;
                        case "3.0":
                            return ModuleDefinitionVersion.V3;
                    }
                }
                else if( xmlReader.GetAttribute( "type" ) == "SkinObject" )
                {
                    return ModuleDefinitionVersion.V2_Skin;
                }
                else if( xmlReader.GetAttribute( "type" ) == "Provider" )
                {
                    return ModuleDefinitionVersion.V2_Provider;
                }
                else
                {
                    return ModuleDefinitionVersion.VUnknown;
                }
            }
            else
            {
                return ModuleDefinitionVersion.VUnknown;
            }
            
            return ModuleDefinitionVersion.VUnknown;
        }


        public override bool Validate(Stream XmlStream)
        {
            SchemaSet.Add("", GetSCPSchemaPath(XmlStream));
            return base.Validate(XmlStream);
        }
    }
}