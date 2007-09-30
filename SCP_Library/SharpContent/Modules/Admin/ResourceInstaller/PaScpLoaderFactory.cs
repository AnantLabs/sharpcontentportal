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
using SharpContent.Entities.Modules.Definitions;

namespace SharpContent.Modules.Admin.ResourceInstaller
{
    public class PaCsnLoaderFactory : ResourceInstallerBase
    {
        private PaInstallInfo _installerInfo;

        public PaInstallInfo InstallerInfo
        {
            get
            {
                return _installerInfo;
            }
        }

        public PaCsnLoaderFactory(PaInstallInfo InstallerInfo)
        {
            _installerInfo = InstallerInfo;
        }

        public PaCsnAdapterBase GetSCPAdapter()
        {
            ModuleDefinitionVersion Version = GetModuleVersion();
            PaCsnAdapterBase retValue = null;

            switch (Version)
            {
                case ModuleDefinitionVersion.V2:

                    retValue = new PaCsnAdapter_V2(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.V3:

                    retValue = new PaCsnAdapter_V3(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.V2_Skin:

                    retValue = new PaCsnAdapter_V2Skin(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.V2_Provider:

                    retValue = new PaCsnAdapter_V2Provider(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.VUnknown:

                    throw (new Exception(EXCEPTION_Format));                    
            }

            return retValue;
        }

        public PaCsnInstallerBase GetSCPInstaller()
        {
            ModuleDefinitionVersion Version = GetModuleVersion();
            PaCsnInstallerBase retValue = null;

            switch (Version)
            {
                case ModuleDefinitionVersion.V2:

                    retValue = new PaCsnInstallerBase(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.V3:

                    retValue = new PaCsnInstaller_V3(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.V2_Skin:

                    retValue = new PaCsnInstaller_V2Skin(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.V2_Provider:

                    retValue = new PaCsnInstaller_V2Provider(InstallerInfo);
                    break;
                case ModuleDefinitionVersion.VUnknown:

                    throw (new Exception(EXCEPTION_Format));
                    
            }

            return retValue;
        }

        private ModuleDefinitionVersion GetModuleVersion()
        {            
            if (InstallerInfo.SCPFile != null)
            {
                MemoryStream buffer = new MemoryStream(InstallerInfo.SCPFile.Buffer, true);
                ModuleDefinitionValidator xval = new ModuleDefinitionValidator();
                return xval.GetModuleDefinitionVersion(buffer);
            }
            else
            {
                return ModuleDefinitionVersion.VUnknown;
            }
        }
    }
}