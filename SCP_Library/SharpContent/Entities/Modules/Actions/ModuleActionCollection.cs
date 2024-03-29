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
using SharpContent.Security;

namespace SharpContent.Entities.Modules.Actions
{
    /// <Summary>Represents a collection of  objects.</Summary>
    // Warning: Custom Attribute Disabled --> [DefaultMemberAttribute("Item")]
    public class ModuleActionCollection : CollectionBase
    {
        /// <Summary>Initializes a new, empty instance of the  class.</Summary>
        public ModuleActionCollection()
        {
        }

        /// <Summary>
        /// Initializes a new instance of the
        /// class containing the elements of the specified source collection.
        /// </Summary>
        /// <Param name="value">A  with which to initialize the collection.</Param>
        public ModuleActionCollection( ModuleActionCollection value )
        {
            this.AddRange( value );
        }

        /// <Summary>
        /// Initializes a new instance of the
        /// class containing the specified array of  objects.
        /// </Summary>
        /// <Param name="value">
        /// An array of  objects with which to initialize the collection.
        /// </Param>
        public ModuleActionCollection( ModuleAction[] value )
        {
            this.AddRange( value );
        }

        public ModuleAction this[ int index ]
        {
            get
            {
                return ( (ModuleAction)this.List[index] );
            }
            set
            {
                this.List[index] = value;
            }
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName )
        {
            return Add( id, title, cmdName, "", "", "", false, SecurityAccessLevel.Anonymous, true, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg )
        {
            return Add( id, title, cmdName, cmdArg, "", "", false, SecurityAccessLevel.Anonymous, true, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon )
        {
            return Add( id, title, cmdName, cmdArg, icon, "", false, SecurityAccessLevel.Anonymous, true, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Param name="url">
        /// The destination URL to redirect the client browser when this action is clicked.
        /// </Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon, string url )
        {
            return Add( id, title, cmdName, cmdArg, icon, url, false, SecurityAccessLevel.Anonymous, true, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Param name="url">
        /// The destination URL to redirect the client browser when this action is clicked.
        /// </Param>
        /// <Param name="useActionEvent">
        /// Determines whether client will receive an event notification
        /// </Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon, string url, bool useActionEvent )
        {
            return Add( id, title, cmdName, cmdArg, icon, url, useActionEvent, SecurityAccessLevel.Anonymous, true, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Param name="url">
        /// The destination URL to redirect the client browser when this action is clicked.
        /// </Param>
        /// <Param name="useActionEvent">
        /// Determines whether client will receive an event notification
        /// </Param>
        /// <Param name="secure">
        /// The security access level required for access to this action
        /// </Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon, string url, bool useActionEvent, SecurityAccessLevel secure )
        {
            return Add( id, title, cmdName, cmdArg, icon, url, useActionEvent, secure, true, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Param name="url">
        /// The destination URL to redirect the client browser when this action is clicked.
        /// </Param>
        /// <Param name="useActionEvent">
        /// Determines whether client will receive an event notification
        /// </Param>
        /// <Param name="secure">
        /// The security access level required for access to this action
        /// </Param>
        /// <Param name="visible">Whether this action will be displayed</Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon, string url, bool useActionEvent, SecurityAccessLevel secure, bool visible )
        {
            return Add( id, title, cmdName, cmdArg, icon, url, useActionEvent, secure, visible, false );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Param name="url">
        /// The destination URL to redirect the client browser when this action is clicked.
        /// </Param>
        /// <Param name="useActionEvent">
        /// Determines whether client will receive an event notification
        /// </Param>
        /// <Param name="secure">
        /// The security access level required for access to this action
        /// </Param>
        /// <Param name="visible">Whether this action will be displayed</Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon, string url, bool useActionEvent, SecurityAccessLevel secure, bool visible, bool newWindow )
        {
            return this.Add( id, title, cmdName, cmdArg, icon, url, "", useActionEvent, secure, visible, newWindow );
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="id">This is the identifier to use for this action.</Param>
        /// <Param name="title">
        /// This is the title that will be displayed for this action
        /// </Param>
        /// <Param name="cmdName">
        /// The command name passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="cmdArg">
        /// The command argument passed to the client when this action is clicked.
        /// </Param>
        /// <Param name="icon">The URL of the icon to place next to this action</Param>
        /// <Param name="url">
        /// The destination URL to redirect the client browser when this action is clicked.
        /// </Param>
        /// <Param name="clientScript">
        /// Client side script to be run when the this action is clicked.
        /// </Param>
        /// <Param name="useActionEvent">
        /// Determines whether client will receive an event notification
        /// </Param>
        /// <Param name="secure">
        /// The security access level required for access to this action
        /// </Param>
        /// <Param name="visible">Whether this action will be displayed</Param>
        /// <Returns>The index of the newly added</Returns>
        public ModuleAction Add( int id, string title, string cmdName, string cmdArg, string icon, string url, string clientScript, bool useActionEvent, SecurityAccessLevel secure, bool visible, bool newWindow )
        {
            ModuleAction moduleAction = new ModuleAction( id, title, cmdName, cmdArg, icon, url, clientScript, useActionEvent, secure, visible, newWindow );
            this.Add( moduleAction );
            return moduleAction;
        }

        /// <Summary>
        /// Add an element of the specified  to the end of the collection.
        /// </Summary>
        /// <Param name="value">An object of type  to add to the collection.</Param>
        /// <Returns>The index of the newly added</Returns>
        public int Add( ModuleAction value )
        {
            return this.List.Add( value );
        }

        /// <Summary>
        /// Adds the contents of another to the end of the collection.
        /// </Summary>
        /// <Param name="value">
        /// A  containing the objects to add to the collection.
        /// </Param>
        public void AddRange( ModuleActionCollection value )
        {
            foreach( ModuleAction moduleAction in value )
            {
                this.Add( moduleAction );
            }
        }

        /// <Summary>
        /// Copies the elements of the specified array to the end of the collection.
        /// </Summary>
        /// <Param name="value">
        /// An array of type containing the objects to add to the collection.
        /// </Param>
        public void AddRange( ModuleAction[] value )
        {                        
            for (int i = 0; i < value.Length; i++)
            {
                this.Add( value[i] );
            }
        }

        /// <Summary>
        /// Gets a value indicating whether the collection contains the specified .
        /// </Summary>
        /// <Param name="value">The  to search for in the collection.</Param>
        /// <Returns>
        /// true if the collection contains the specified object; otherwise, false.
        /// </Returns>
        public bool Contains( ModuleAction value )
        {
            return this.List.Contains( value );
        }

        /// <Summary>
        /// Gets the index in the collection of the specified ,
        /// if it exists in the collection.
        /// </Summary>
        /// <Param name="value">The  to locate in the collection.</Param>
        /// <Returns>
        /// The index in the collection of the specified object, if found; otherwise, -1.
        /// </Returns>
        public int IndexOf( ModuleAction value )
        {
            return this.List.IndexOf( value );
        }

        /// <Summary>
        /// Add an element of the specified  to the collection at the designated index.
        /// </Summary>
        /// <Param name="index">
        /// An Integer to indicate the location to add the object to the collection.
        /// </Param>
        /// <Param name="value">An object of type  to add to the collection.</Param>
        public void Insert( int index, ModuleAction value )
        {
            this.List.Insert( index, value );
        }

        /// <Summary>Remove the specified object of type  from the collection.</Summary>
        /// <Param name="value">
        /// An object of type  to remove from the collection.
        /// </Param>
        public void Remove( ModuleAction value )
        {
            this.List.Remove( value );
        }
    }
}