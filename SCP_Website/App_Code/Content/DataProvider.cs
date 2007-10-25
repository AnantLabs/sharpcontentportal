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
using SharpContent;
using System.Data;

namespace SharpContent.Modules.Content
{

    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The DataProvider Class Is an abstract class that provides the DataLayer
    /// for the Html Module.
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    /// 	[cnurse]	9/23/2004	Moved Html to a separate Project
    /// </history>
    /// -----------------------------------------------------------------------------
    public abstract class DataProvider
    {

        #region "Shared/Static Methods"

        // singleton reference to the instantiated object 
        private static DataProvider _objProvider = null;

        // constructor
        static DataProvider()
        {
            CreateProvider();
        }

        // dynamically create provider
        private static void CreateProvider()
        {
            _objProvider = (DataProvider)Framework.Reflection.CreateObject("data", "SharpContent.Modules.Content", "");
        }

        // return the provider
        public static DataProvider Instance()
        {
            return _objProvider;
        }

        #endregion

        #region "Abstract methods"

        public abstract void AddContent(int contentId, int moduleId, string desktopHtml, string desktopSummary, int userID, bool publish);
        public abstract IDataReader GetContentVersions(int moduleId);
        public abstract IDataReader GetContent(int moduleId);
        public abstract IDataReader GetContentById(int contentId);
        public abstract void UpdateContent(int contentId, string desktopHtml, string desktopSummary, int userID, bool publish);

        #endregion

    }

}
