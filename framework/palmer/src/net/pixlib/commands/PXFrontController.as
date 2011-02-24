/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.commands
{
	import net.pixlib.core.PXAbstractLocator;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginDebug;
	import net.pixlib.utils.PXClassUtils;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * A base class for an application specific front controller,
	 * that is able to dispatch control following particular events
	 * to appropriate command classes.
	 * <p>
	 * The Front Controller is the centralised request handling class in a
	 * pixLib plugin or application. It could be used with or without the
	 * plugin architecture of pixLib. By default all classes which will extend
	 * <code>PXAbstractPlugin</code> will own an instance of the 
	 * <code>PXFrontController</code> class.
	 * </p><p>
	 * The role of the Front Controller is to first register all the different
	 * events that it is capable of handling against worker classes, called
	 * command classes.  On hearing an application event, the Front Controller
	 * will look up its table of registered events, find the appropriate
	 * command for handling the event, before dispatching control to the
	 * command by calling its execute() method.
	 * </p><p>
	 * When used inside a plugin the Front Controller is automatically registered
	 * as a listener of all private events. It will receive all private events 
	 * dispatched in all plugin's MVC components. 
	 * </p>
	 * 
	 * @author Francis Bourre
	 * 									
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXFrontController extends PXAbstractLocator implements PXCommandListener
	{
		protected var oOwner 		: PXPlugin;
		protected var dicoCommands 	: Dictionary;
		
		/**
		 * Returns the owner of this controller
		 * 
		 * @return 	the owner plugin of this controller
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function get owner() : PXPlugin
		{
			return oOwner;
		}
		
		/**
		 * Returns default PXFrontController used by the PXBasePlugin instance.
		 * 
		 * @return base PXFrontController used by the PXBasePlugin instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getBaseController() : PXFrontController
		{
			return PXBasePlugin.getInstance().controller;
		}
		
		/**
		 * Creates a new Front Controller instance for the passed-in
		 * plugin. If the plugin argument is omitted, the Front Controller
		 * is owned by the global instance of the <code>PXBasePlugin</code>
		 * class.
		 * 
		 * @param	owner	plugin instance which owns the controller
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXFrontController( plugin : PXPlugin = null ) 
		{
			oOwner = ( plugin == null ) ? PXBasePlugin.getInstance() : plugin;
			if ( plugin == null ) PXEventBroadcaster.getInstance().addListener( this );
			
			super( PXCommand, null, PXPluginDebug.getInstance( owner ) );
			
			dicoCommands = new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		override public function register( eventName : String, command : Object ) : Boolean
		{
			try
			{
				if ( command is Class )
				{
					return pushCommandClass( eventName, command as Class );
				} 
				else
				{
					return pushCommandInstance( eventName, command as PXCommand );
				}

			} 
			catch( e : Error )
			{
				logger.fatal( e.message, this );
				throw e;
			}
			
			return false;
		}

		/**
		 * Registers the passed-in command class to be triggered each time
		 * the controller will receive an event of type <code>eventType</code>.
		 * <p>
		 * The passed-in command class must at least implement the <code>PXCommand</code>
		 * interface. If the class doesn't inherit from <code>PXCommand</code> the
		 * association failed and an exception is thrown.
		 * </p><p>
		 * If there is already a command or a class associated with the passed-in event
		 * type, the association failed and an exception is thrown.
		 * </p>
		 * @param	eventType	 name of the event type with which the command
		 * 						 will be registered
		 * @param	commandClass class to associate with the passed-in event type
		 * @return	<code>true</code> if the command class has been succesfully	
		 * 			registered with the passed-in event type 
		 * @throws 	<code>PXIllegalArgumentException</code> — There is already
		 * 			a command or class registered with the specified event type. 			
		 * @throws 	<code>PXIllegalArgumentException</code> — The passed-in command 
		 * 			class doesn't inherit from PXCommand interface.
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function pushCommandClass( eventType : String, commandClass : Class ) : Boolean
		{
			var key : String = eventType.toString();
			
			if ( isRegistered( key ) )
			{
				throw new PXIllegalArgumentException("There is already a command class registered with '" + key + "' name in " + this, this);
			} 
			else if( !PXClassUtils.inherit( commandClass, PXCommand ) )
			{
				throw new PXIllegalArgumentException("The class '" + commandClass + "' doesn't inherit from Command interface in " + this, this);
			} 
			else
			{
				mMap.put( key, commandClass );
				return true;
			}
		}

		/**
		 * Registers the passed-in command to be triggered each time
		 * the controller will receive an event of type <code>eventType</code>.
		 * <p>
		 * If there is already a class or a command associated with the passed-in
		 * event type, the association failed and an exception is thrown.
		 * </p>
		 * @param	eventType	name of the event type with which the command
		 * 						will be registered
		 * @param	command		<code>command</code> to associate with the passed-in event type
		 * 
		 * @return	<code>true</code> if the command has been succesfully	
		 * 			registered with the passed-in event type 
		 * @throws 	<code>PXIllegalArgumentException</code> — There is already
		 * 			a command or class registered with the specified event type. 			
		 * @throws 	<code>PXNullPointerException</code> — The passed-in command 
		 * 			is null
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function pushCommandInstance( eventType : String, command : PXCommand ) : Boolean
		{
			var key : String = eventType.toString();
			
			if ( isRegistered( key ) )
			{
				throw new PXIllegalArgumentException("There is already a command class registered with '" + key + "' name in " + this, this);
			} 
			else if( command == null )
			{
				throw new PXIllegalArgumentException("The passed-in command is null in " + this, this);
			} 
			else
			{
				mMap.put( key, command );
				return true;
			}
		}

		/**
		 * Removes the class or the command registered with the
		 * passed-in event type.
		 * 
		 * @param	eventType event type to unregister
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function remove( eventType : String ) : void
		{
			mMap.remove( eventType.toString() );
		}

		/**
		 * Handles all events received by this controller.
		 * For each received event the controller will look up
		 * its registered events table. If a command or
		 * a class is registered, the controller proceeds.
		 * <p>
		 * Command instance is stored in a specific map in order
		 * to keep a reference to that command during all its
		 * execution, and prevent it to be collected by the
		 * garbage collector. The front controller will
		 * automatically remove the reference when it will receive
		 * <code>onCommandEnd</code> event from the command.
		 * </p>
		 * 
		 * @param	event event object dispatched by the
		 * 			source object
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function handleEvent( event : Event ) : void
		{
			var type : String = event.type.toString();
			var cmd : PXCommand;
			
			try
			{
				cmd = locate( type ) as PXCommand;

			} catch ( e : Error )
			{
				logger.debug( "handleEvent() fails to retrieve command associated with '" + type + "' event type.", this );
			}

			if ( cmd != null )
			{
				executeCommand( event, cmd );
			}
		}

		/**
		 * Executes passed-in command with event as argument. 
		 * 
		 * @param	event	<code>Event</code>.
		 * @param command	<code>PXCommand</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function executeCommand( event : Event, command : PXCommand  ) : void
		{
			dicoCommands[ command ] = true;
			( command as PXCommand ).addCommandListener( this );
			command.execute( event );
		}

		/**
		 * Called when the command process is beginning.
		 * 
		 * @param	e	event dispatched by the command
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onCommandStart( event : PXCommandEvent ) : void
		{
			// do nothing.
		}

		/**
		 * Catch callback events from asynchronous commands triggered
		 * by this front controller. When the controller receive an event
		 * from the command, that command is removed from the controller
		 * storage.
		 * 
		 * @param	e	event object propagated by the command
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onCommandEnd ( event : PXCommandEvent ) : void
		{
			delete dicoCommands[ event.target ];
		}

		/**
		 * Returns the command linked to specified <code>eventType</code>.
		 * If there's no command linked, this method call will fail and 
		 * throw an error.
		 * <p>
		 * The <code>locate</code> method will always return a <code>PXCommand</code>
		 * instance, even if it was a class which was registered with this key.
		 * The <code>locate</code> will instanciate the command and then return it.
		 * </p> 
		 * @throws 	<code>PXNoSuchElementException</code> — There is no command
		 * 			registered with the passed-in event type
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function locate( eventType : String ) : Object
		{
			var searchComand : Object;

			if ( isRegistered( eventType ) ) 
			{
				searchComand = mMap.get( eventType );

			} 
			else
			{
				throw new PXNoSuchElementException("Can't find Command instance with '" + eventType + "' name in " + this, this);
			}

			if ( searchComand is Class )
			{
				var cmd : PXCommand = new ( searchComand as Class )();
				if ( cmd is PXAbstractCommand ) ( cmd as PXAbstractCommand ).owner = owner;
				return cmd;

			} else if ( searchComand is PXCommand )
			{
				if ( searchComand is PXAbstractCommand ) 
				{
					var acmd : PXAbstractCommand = ( searchComand as PXAbstractCommand );
					if ( acmd.owner == null ) acmd.owner = owner;
				}

				return searchComand;
			}

			return null;
		}

		/**
		 * Adds all key/commands associations within the passed-in
		 * <code>Dictionnary</code> in the current front controller.
		 * The errors thrown by the <code>pushCommandClass</code> and
		 * <code>pushCommandInstance</code> are also thrown in the
		 * <code>add</code> method.
		 * 
		 * @param	dico a dictionary object used to fill this controller
		 * @throws 	<code>PXIllegalArgumentException</code> — There is already
		 * 			a command or class registered with a key in the dictionary. 
		 * @throws 	<code>PXIllegalArgumentException</code> — A command class
		 * 			in the dictionary doesn't inherit from PXCommand interface.			
		 * @throws 	<code>PXNullPointerException</code> — A command in the
		 * 			dictionary is null
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function add( dico : Dictionary ) : void
		{
			for ( var key : * in dico ) 
			{
				try
				{
					var cmd : Object = dico[ key ] as Object;

					if ( cmd is Class )
					{
						pushCommandClass( key, cmd as Class );

					} else
					{
						pushCommandInstance( key, cmd as PXCommand );
					}

				} catch( e : Error )
				{
					e.message = this + ".add() fails. " + e.message;
					logger.error( e.message, this );
					throw( e );
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			super.release();
			oOwner = null ;
		}
		
		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function toString () : String
		{
			return super.toString() + ( oOwner != null ? " of " + oOwner : "" );
		}
	}
}