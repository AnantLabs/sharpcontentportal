//
// Sharp Content Portal - http://www.sharpcontentportal.com
// Copyright (c) 2002-2005
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
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
//

using System;
using System.Configuration;
using System.Data;

namespace SharpContent.Modules.Content
{

    public class ContentInfo
    {
        // local property declarations
        private int _contentId;
        private int _contentVersion;
        private int _moduleId;
        private string _deskTopHTML;
        private string _desktopSummary;
        private int _createdByUserID;
        private string _createdByUsername;
        private DateTime _createdDate;
        private bool _publish;

        // initialization
        public ContentInfo()
        {
        }

        // public properties
        public int ContentId
        {
            get { return _contentId; }
            set { _contentId = value; }
        }

        public int ContentVersion
        {
            get { return _contentVersion; }
            set { _contentVersion = value; }
        }

        public int ModuleId
        {
            get { return _moduleId; }
            set { _moduleId = value; }
        }

        public string DeskTopHTML
        {
            get { return _deskTopHTML; }
            set { _deskTopHTML = value; }
        }

        public string DesktopSummary
        {
            get { return _desktopSummary; }
            set { _desktopSummary = value; }
        }

        public int CreatedByUserID
        {
            get { return _createdByUserID; }
            set { _createdByUserID = value; }
        }

        public string CreatedByUsername
        {
            get { return _createdByUsername; }
            set { _createdByUsername = value; }
        }

        public DateTime CreatedDate
        {
            get { return _createdDate; }
            set { _createdDate = value; }
        }

        public bool Publish
        {
            get { return _publish; }
            set { _publish = value; }
        }
    }
}

