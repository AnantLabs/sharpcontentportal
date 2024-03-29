#region SharpContent License
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
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
#endregion

using System;
using System.Collections;

namespace SharpContent.UI.Utilities
{
    public class FunctionalityCollection : CollectionBase
    {
        public void Add( FunctionalityInfo f )
        {
            InnerList.Add( f );
        }

        public virtual FunctionalityInfo this[ int index ]
        {
            get
            {
                return (FunctionalityInfo)( base.List[index] );
            }
            set
            {
                base.List[index] = value;
            }
        }

        public virtual FunctionalityInfo this[ ClientAPI.ClientFunctionality functionality ]
        {
            get
            {
                FunctionalityInfo _fInfo = null;
                foreach( FunctionalityInfo fInfo in List )
                {
                    if( fInfo.Functionality == functionality )
                    {
                        _fInfo = fInfo;
                        break;
                    }
                }
                return _fInfo;
            }
            set
            {
                bool bFound = false;
                foreach( FunctionalityInfo fInfo in List )
                {
                    if( fInfo.Functionality == functionality )
                    {
                        //fInfo = value;
                        bFound = true;
                        break;
                    }
                }
                if( ! bFound )
                {
                    throw new Exception( "Item Not Found" );
                }
            }
        }
    }
}