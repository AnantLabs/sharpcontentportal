//
// Sharp Content Portal - http://www.SharpContentPortal.com
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

using System.Collections;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Data;
using System.Web.UI;
using System.Web.UI.Design;
using System;

namespace SharpContent.UI.Design.WebControls
{
	public class SCPTreeDesigner : ControlDesigner
	{

		public override string GetDesignTimeHtml()
		{

			string designTimeHTML = null;

			try {
				designTimeHTML = "<Div>This is a PlaceHolder.<br>Additional design-time support will be <br>added in future versions</Div>";
			}
			catch (Exception e) {
				designTimeHTML = GetErrorDesignTimeHtml(e);
			}
			return designTimeHTML;
		}

	}
}

