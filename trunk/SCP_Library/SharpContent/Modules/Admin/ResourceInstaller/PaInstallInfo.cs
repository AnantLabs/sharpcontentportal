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
using System.Collections;

namespace SharpContent.Modules.Admin.ResourceInstaller
{
    public class PaInstallInfo
    {
        private PaFile _SCP;
        private Hashtable _FileTable;
        private PaLogger _Log;
        private string _Path;

        public PaInstallInfo()
        {
            
            this._Log = new PaLogger();
            this._Path = "";
            this._FileTable = new Hashtable();
        }

        public PaFile SCPFile
        {
            get
            {
                return this._SCP;
            }
            set
            {
                this._SCP = value;
            }
        }

        public Hashtable FileTable
        {
            get
            {
                return this._FileTable;
            }
            set
            {
                this._FileTable = value;
            }
        }

        public PaLogger Log
        {
            get
            {
                return this._Log;
            }
            set
            {
                this._Log = value;
            }
        }

        public string SitePath
        {
            get
            {
                return this._Path;
            }
            set
            {
                this._Path = value;
            }
        }
    }
}