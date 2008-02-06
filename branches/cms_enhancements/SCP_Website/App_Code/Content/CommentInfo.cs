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

    public class CommentInfo
    {
        // local property declarations
        private int _commentId;
        private int _contentId;
        private int _createdByUserId;
        private string _createdByUsername;
        private string _createdByFirstName;
        private string _createdByLastName;
        private DateTime _commentDate;
        private string _comment;

        // initialization
        public CommentInfo()
        {
        }

        // public properties
        public int CommentId
        {
            get { return _commentId; }
            set { _commentId = value; }
        }

        public int ContentId
        {
            get { return _contentId; }
            set { _contentId = value; }
        }

        public int CreatedByUserId
        {
            get { return _createdByUserId; }
            set { _createdByUserId = value; }
        }

        public string CreatedByUsername
        {
            get { return _createdByUsername; }
            set { _createdByUsername = value; }
        }

        public string CreatedByFirstName
        {
            get { return _createdByFirstName; }
            set { _createdByFirstName = value; }
        }

        public string CreatedByLastName
        {
            get { return _createdByLastName; }
            set { _createdByLastName = value; }
        }

        public DateTime CommentDate
        {
            get { return _commentDate; }
            set { _commentDate = value; }
        }

        public string Comment
        {
            get { return _comment; }
            set { _comment = value; }
        }       
    }
}

