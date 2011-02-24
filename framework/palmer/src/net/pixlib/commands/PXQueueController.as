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
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.plugin.PXPlugin;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * <code>PXQueueController</code> enqueues requests 
	 * of the same type and process them one by one at 
	 * the same time. It ensures that two requests of 
	 * the same type can't be processed at the same time.
	 * 
	 * @author	Francis Bourre
	 * @see PXFrontController
	 * 									
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXQueueController extends PXFrontController
	{
		protected var dRunningCommandMap 		: Dictionary;
		protected var dCommandCollectionMap 	: Dictionary;
		protected var dCommandMap 				: Dictionary;
		
		/**
		 * Creates a new PXQueueController instance for the passed-in
		 * plugin.
		 * 
		 * @param	owner	<code>Plugin</code> instance which owns the controller
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXQueueController(  owner : PXPlugin = null  ) 
		{
			super( owner );

			dRunningCommandMap 	= new Dictionary( true );
			dCommandCollectionMap 	= new Dictionary( true );
			dCommandMap			= new Dictionary( true );
		}
		
		/**
		 * Return true if eventType is associated with command.
		 * 
		 * @param	eventType	<code>String</code>.
		 * 
		 * @return <code>true</code>  if eventType is registered with command.
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hasCommandQueued( eventType : String ) : Boolean
		{
			return getCommandCollection( eventType ).length > 0;
		}
		
		/**
		 * Return true if command registered with eventType is running.
		 * 
		 * @param	eventType	event type registered with command is running.
		 * 
		 * @return <code>true</code>  if eventType is registered with command.
		 * 									
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRunning( eventType : String ) : Boolean
		{
			return dRunningCommandMap[ eventType ];
		}

		/**
		 * Called when the command process is over.
		 * 
		 * @param	event	event dispatched by the command
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function onCommandEnd ( event : PXCommandEvent ) : void
		{
			var eventType 	: String 	= dCommandMap[ event.command ] as String;
			dCommandMap[ event.command ] = null;
			
			super.onCommandEnd( event );
			
			if ( hasCommandQueued( eventType ) )
			{
				executeNextCommand( eventType );

			} else
			{
				dCommandCollectionMap[ eventType ] = null;
				dRunningCommandMap[ eventType ] = null;
			}
		}

		/** @private */
		override protected function executeCommand( event : Event, command : PXCommand  ) : void
		{
			getCommandCollection( event.type ).push( new SequencerItem( event, command ) );
			if ( !isRunning( event.type ) ) executeNextCommand( event.type );
		}
		
		/** @private */
		protected function getCommandCollection( eventType : String ) : Array
		{
			if ( !(dCommandCollectionMap[eventType] is Array) ) dCommandCollectionMap[eventType] = new Array();
			return dCommandCollectionMap[eventType];
		}
		
		/** @private */
		protected function executeNextCommand( eventType : String ) : void
		{
			dRunningCommandMap[ eventType ] = true;

			var item : SequencerItem = getCommandCollection(eventType).shift() as SequencerItem;
			dCommandMap[ item.commandItem ] = eventType;

			super.executeCommand( item.eventItem, item.commandItem );
		}
	}
}

import net.pixlib.commands.PXCommand;

import flash.events.Event;

internal class SequencerItem
{
	public var eventItem 	: Event;
	public var commandItem 	: PXCommand;
	public function SequencerItem( event : Event, command : PXCommand ) 
	{
		this.eventItem 		= event;
		this.commandItem 	= command;
	}
}