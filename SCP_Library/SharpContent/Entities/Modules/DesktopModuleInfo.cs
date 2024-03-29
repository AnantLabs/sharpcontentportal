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
namespace SharpContent.Entities.Modules
{
    public class DesktopModuleInfo
    {
        private string _BusinessControllerClass;
        private string _Description;
        private int _DesktopModuleID;
        private string _FolderName;
        private string _FriendlyName;
        private bool _IsAdmin;
        private bool _IsPremium;
        private string _ModuleName;
        private int _SupportedFeatures;
        private string _Version;
        private string _CompatibleVersions;

        public string BusinessControllerClass
        {
            get
            {
                return this._BusinessControllerClass;
            }
            set
            {
                this._BusinessControllerClass = value;
            }
        }

        public string Description
        {
            get
            {
                return this._Description;
            }
            set
            {
                this._Description = value;
            }
        }

        public int DesktopModuleID
        {
            get
            {
                return this._DesktopModuleID;
            }
            set
            {
                this._DesktopModuleID = value;
            }
        }

        public string FolderName
        {
            get
            {
                return this._FolderName;
            }
            set
            {
                this._FolderName = value;
            }
        }

        public string FriendlyName
        {
            get
            {
                return this._FriendlyName;
            }
            set
            {
                this._FriendlyName = value;
            }
        }

        public bool IsAdmin
        {
            get
            {
                return this._IsAdmin;
            }
            set
            {
                this._IsAdmin = value;
            }
        }

        public bool IsPortable
        {
            get
            {
                return this.GetFeature( DesktopModuleSupportedFeature.IsPortable );
            }
            set
            {
                this.UpdateFeature( DesktopModuleSupportedFeature.IsPortable, value );
            }
        }

        public bool IsPremium
        {
            get
            {
                return this._IsPremium;
            }
            set
            {
                this._IsPremium = value;
            }
        }

        public bool IsSearchable
        {
            get
            {
                return this.GetFeature( DesktopModuleSupportedFeature.IsSearchable );
            }
            set
            {
                this.UpdateFeature( DesktopModuleSupportedFeature.IsSearchable, value );
            }
        }

        public bool IsUpgradeable
        {
            get
            {
                return this.GetFeature( DesktopModuleSupportedFeature.IsUpgradeable );
            }
            set
            {
                this.UpdateFeature( DesktopModuleSupportedFeature.IsUpgradeable, value );
            }
        }

        public string ModuleName
        {
            get
            {
                return this._ModuleName;
            }
            set
            {
                this._ModuleName = value;
            }
        }

        public int SupportedFeatures
        {
            get
            {
                return this._SupportedFeatures;
            }
            set
            {
                this._SupportedFeatures = value;
            }
        }

        public string Version
        {
            get
            {
                return this._Version;
            }
            set
            {
                this._Version = value;
            }
        }

        public string CompatibleVersions
        {
            get
            {
                return _CompatibleVersions;
            }
            set
            {
                _CompatibleVersions = value;
            }
        }


        private void ClearFeature( DesktopModuleSupportedFeature Feature )
        {
            //And with the 1's complement of Feature to Clear the Feature flag
            this.SupportedFeatures = ( (int)( ( (DesktopModuleSupportedFeature)this.SupportedFeatures ) & ( ~ Feature ) ) );
        }

        private bool GetFeature( DesktopModuleSupportedFeature Feature )
        {
            bool isSet = false;
            //And with the Feature to see if the flag is set
            if( ( ( (DesktopModuleSupportedFeature)this.SupportedFeatures ) & Feature ) != Feature )
            {
                return isSet;
            }
            else
            {
                return true;
            }
        }

        private void SetFeature( DesktopModuleSupportedFeature Feature )
        {
            //Or with the Feature to Set the Feature flag
            this.SupportedFeatures = ( (int)( ( (DesktopModuleSupportedFeature)this.SupportedFeatures ) | Feature ) );
        }

        private void UpdateFeature( DesktopModuleSupportedFeature Feature, bool IsSet )
        {
            if( IsSet )
            {
                this.SetFeature( Feature );
                return;
            }
            this.ClearFeature( Feature );
        }
    }
}