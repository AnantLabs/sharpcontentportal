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
using System.ComponentModel;
using System.Web.UI.Design;

namespace SharpContent.UI.WebControls.Design
{
    public class PropertyEditorControlDesigner : ControlDesigner
    {
        public override string GetDesignTimeHtml()
        {
            //TODO:  There is a bug here somewhere that results in a design-time rendering error when the control is re-rendered [jmb]
            string DesignTimeHtml = null;
            //Dim control As PropertyEditorControl = CType(Component, PropertyEditorControl)

            //Try
            //    If control.DataSource Is Nothing Then
            //        control.DataSource = New DefaultDesignerInfo
            //        control.DataBind()
            //    End If
            //    DesignTimeHtml = MyBase.GetDesignTimeHtml()
            //Catch ex As Exception
            //    DesignTimeHtml = GetErrorDesignTimeHtml(ex)
            //Finally
            //    If TypeOf control.DataSource Is DefaultDesignerInfo Then
            //        control.DataSource = Nothing
            //        control.DataBind()
            //    End If
            //End Try

            if (DesignTimeHtml == null)
            {
                DesignTimeHtml = GetEmptyDesignTimeHtml();
            }

            return DesignTimeHtml;
        }

        public override void Initialize( IComponent component )
        {
            if( ! ( component is PropertyEditorControl ) )
            {
                throw new ArgumentException( "Component must be of Type PropertyEditorControl", "component" );
            }
            else
            {
                base.Initialize( component );
            }
        }
    }
}