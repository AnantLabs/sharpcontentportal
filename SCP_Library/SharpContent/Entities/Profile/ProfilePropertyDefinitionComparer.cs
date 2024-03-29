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

namespace SharpContent.Entities.Profile
{
    /// <Summary>
    /// The ProfilePropertyDefinitionComparer class provides an implementation of
    /// IComparer to sort the ProfilePropertyDefinitionCollection by ViewOrder
    /// </Summary>
    public class ProfilePropertyDefinitionComparer : IComparer
    {
        /// <Summary>Compares two ProfilePropertyDefinition objects</Summary>
        /// <Param name="x">A ProfilePropertyDefinition object</Param>
        /// <Param name="y">A ProfilePropertyDefinition object</Param>
        /// <Returns>
        /// An integer indicating whether x greater than y, x=y or x less than y
        /// </Returns>
        public virtual int Compare( object x, object y )
        {
            return ( (ProfilePropertyDefinition)x ).ViewOrder.CompareTo( ( (ProfilePropertyDefinition)y ).ViewOrder );
        }
    }
}