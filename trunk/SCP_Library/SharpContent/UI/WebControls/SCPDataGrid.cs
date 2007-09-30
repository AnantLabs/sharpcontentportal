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
using System.Web.UI.WebControls;

namespace SharpContent.UI.WebControls
{
    /// <Summary>
    /// The SCPDataGrid control provides an Enhanced Data Grid, that supports other
    /// column types
    /// </Summary>
    public class SCPDataGrid : DataGrid
    {

        public event SCPDataGridCheckedColumnEventHandler ItemCheckedChanged
        {
            add
            {
                this.ItemCheckedChangedEvent += value;
            }
            remove
            {
                this.ItemCheckedChangedEvent -= value;
            }
        }
        private SCPDataGridCheckedColumnEventHandler ItemCheckedChangedEvent;

        protected override void CreateControlHierarchy( bool useDataSource )
        {
            base.CreateControlHierarchy( useDataSource );
        }

        /// <Summary>Called when the grid is Data Bound</Summary>
        protected override void OnDataBinding( EventArgs e )
        {
            foreach (DataGridColumn column in this.Columns)
            {
                if (column.GetType() == typeof(CheckBoxColumn))
                {
                    //Manage CheckBox column events
                    CheckBoxColumn cbColumn = (CheckBoxColumn)column;
                    cbColumn.CheckedChanged += new SCPDataGridCheckedColumnEventHandler(OnItemCheckedChanged);
                }
            }
        }

        /// <Summary>
        /// Centralised Event that is raised whenever a check box is changed.
        /// </Summary>
        private void OnItemCheckedChanged( object sender, SCPDataGridCheckChangedEventArgs e )
        {
            if (ItemCheckedChangedEvent != null)
            {
                ItemCheckedChangedEvent(sender, e);
            }
        }

        protected override void PrepareControlHierarchy()
        {
            base.PrepareControlHierarchy();
        }
    }
}