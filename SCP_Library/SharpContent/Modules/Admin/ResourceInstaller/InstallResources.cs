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
using SharpContent.Services.Exceptions;
using SharpContent.Services.Scheduling;

namespace SharpContent.Modules.Admin.ResourceInstaller
{
    public class InstallResources : SchedulerClient
    {
        public InstallResources( ScheduleHistoryItem objScheduleHistoryItem )
        {
            this.ScheduleHistoryItem = objScheduleHistoryItem;
        }

        public override void DoWork()
        {
            try
            {
                //notification that the event is progressing
                this.Progressing(); //OPTIONAL

                ResourceInstaller objResourceInstaller = new ResourceInstaller();
                objResourceInstaller.Install();

                this.ScheduleHistoryItem.Succeeded = true; //REQUIRED

                this.ScheduleHistoryItem.AddLogNote( "Resource Installation Complete." ); //OPTIONAL
            }
            catch( Exception exc ) //REQUIRED
            {
                this.ScheduleHistoryItem.Succeeded = false; //REQUIRED

                this.ScheduleHistoryItem.AddLogNote( "Resource Installation Failed. " + exc.ToString() ); //OPTIONAL

                //notification that we have errored
                this.Errored( ref exc ); //REQUIRED

                //log the exception
                Exceptions.LogException( exc ); //OPTIONAL
            }
        }
    }
}