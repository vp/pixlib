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
	import net.pixlib.events.PXObjectEvent;
	import net.pixlib.exceptions.PXIllegalStateException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.plugin.PXPlugin;
	import flash.events.Event;

	/**
	 *  Dispatched when sequencer starts.
	 *  
	 *  @eventType net.pixlib.commands.PXSequencer.onSequencerStartEVENT
	 */
	[Event(name="onSequencerStart", type="net.pixlib.commands.PXSequencer")]
	/**
	 *  Dispatched when a new command is ready to be executed.
	 *  
	 *  @eventType net.pixlib.commands.PXSequencer.onSequencerProgressEVENT
	 */
	[Event(name="onSequencerProgress", type="net.pixlib.commands.PXSequencer")]
	/**
	 *  Dispatched when sequencer ends.
	 *  
	 *  @eventType net.pixlib.commands.PXSequencer.onSequencerEndEVENT
	 */
	[Event(name="onSequencerEnd", type="net.pixlib.commands.PXSequencer")]
	/**
	 * <code>PXSequencer</code> object encapsulate a set of <code>PXCommands</code>
	 * to execute.
	 * 
	 * <p>PXSequencer is a first-in first-out stack (FIFO) where commands
	 * are executed in the order they were registered.</p>
	 * 
	 * <p>Default, the <code>PXCommandEvent</code> object received in the <code>execute</code> is passed
	 * to each commands contained in this sequencer.<br />
	 * But you can relay event from command to command using 
	 * <code>useEventFlow</code> property.</p>
	 * 
	 * <p>The Sequencer class extends <code>PXAbstractCommand</code>
	 * and so, dispatch an <code>onCommandEnd</code> event at the execution end
	 * of all commands.</p> 
	 * 
	 * @author Romain Ecarnot
	 * @author Francis Bourre
	 * @author Michael Barbero
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXSequencer extends PXAbstractCommand 
	implements PXMacroCommand, PXCommandListener
	{
		// --------------------------------------------------------------------
		// Events
		// --------------------------------------------------------------------
		/**
		 * Name of the event dispatched at the start of the command's process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const onSequencerStartEVENT : String = "onSequencerStart";
		/**
		 * Name of the event dispatched at each step of computation.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const onSequencerProgressEVENT : String = "onSequencerProgress";
		/**
		 * Name of the event dispatched at the stop of the command's process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const onSequencerEndEVENT : String = "onSequencerEnd";
		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		/**  
		 * Stores commands list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var aCommands : Vector.<PXCommand>;
		/** 
		 * Current command index. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nIndex : int;
		/** 
		 * Main source event data. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var eEvent : Event;
		/** 
		 * Returns true if a command is currently processing.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bCommandProcessing : Boolean;
		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**
		 *  Indicates if Sequencer use command event flow or only 
		 *  main source event data.
		 *  
		 *  <p>If <code>true</code> next command is executed using 
		 *  last command event result.<br />
		 *  If <code>false</code>, only use the main source event data 
		 *  passed-in Sequencer.execute() call.</p>
		 *  
		 *  @default false
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var useEventFlow : Boolean;

		/**
		 * @inheritDoc
		 */
		override public function set owner(plugin : PXPlugin) : void
		{
			super.owner = plugin;

			var length : Number = aCommands.length;
			var cmd : PXAbstractCommand;
			while ( --length - (-1 ) ) if ( ( cmd = aCommands[ length ] as PXAbstractCommand ) != null ) cmd.owner = owner;
		}

		/**
		 * Returns the number of commands stored in this sequencer.
		 * 
		 * @return	the number of commands stored in this sequencer
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get length() : uint
		{
			return aCommands.length;
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * Creates a new instance sequencer.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXSequencer()
		{
			aCommands = new Vector.<PXCommand>();

			useEventFlow = false;
			bCommandProcessing = false;
		}

		/**
		 * @inheritDoc
		 */
		public function addCommand(command : PXCommand) : Boolean
		{
			return addCommandEnd(command);
		}

		/**
		 * Adds passed-in <code>command</code> before passed-in <code>searchCommand</code>.
		 * 
		 * <p><code>indexCommand</code> must be registered in sequencer command list to find 
		 * his position.<br />
		 * The <code>command</code> command is inserted before 
		 * <code>searchCommand</code> command.</p>
		 * 
		 * @param	searchCommand	PXCommand to search
		 * @param	command			<code>PXCommand</code> to add before <code>searchCommand</code> 
		 * 							command.
		 * 							
		 * @return	<code>true</code> if <code>command</code> is was successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addCommandBefore(searchCommand : PXCommand, command : PXCommand) : Boolean
		{
			var index : int = aCommands.indexOf(searchCommand) ;
			if ( command == null && index != -1) return false;

			return addCommandAt(index, command) ;
		}

		/**
		 * Adds passed-in <code>command</code> after passed-in 
		 * <code>searchCommand</code>. 
		 * 
		 * <p><code>searchCommand</code> must be registered in sequencer to find 
		 * his position.<br />
		 * The <code>command</code> command is added after 
		 * <code>searchCommand</code> command.</p>
		 * 
		 * @param	searchCommand	PXCommand to search
		 * @param	command			PXCommand to add after <code>indexCommand</code> 
		 * 							command.
		 * 					
		 * @return	<code>true</code> if <code>command</code> is was successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addCommandAfter(searchCommand : PXCommand, command : PXCommand) : Boolean
		{
			var index : int = aCommands.indexOf(searchCommand) ;
			if ( command == null && index != -1) return false;

			return addCommandAt(index + 1, command) ;
		}

		/**
		 * Adds passed-in command in first position in sequencer.
		 * 
		 * @param	command	<code>PXCommand</code> to add.
		 * 
		 * @return	<code>true</code> if <code>PXCommand</code> is was successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addCommandStart(command : PXCommand) : Boolean
		{
			return addCommandAt(0, command) ;
		}

		/**
		 * Adds passed-in command at last position in sequencer.
		 * 
		 * @param	command	<code>PXCommand</code> to add.
		 * 
		 * @return	<code>true</code> if <code>PXCommand</code> is was successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addCommandEnd(command : PXCommand) : Boolean
		{
			return addCommandAt(aCommands.length, command) ;
		}

		/**
		 * @inheritDoc
		 */
		public function removeCommand(command : PXCommand) : Boolean
		{
			if ( !running )
			{
				var index : int = aCommands.indexOf(command);
				if ( index == -1 ) return false;
				while ( ( index = aCommands.indexOf(command) ) != -1 ) aCommands.splice(index, 1);
				return true;
			}

			return false;
		}

		/**
		 * Returns <code>true</code> if the passed-in command is stored
		 * in this batch.
		 * 
		 * @param	command <code>PXCommand</code> object to look at
		 * @return	<code>true</code> if the passed-in command is stored
		 * 		   	in the <code>PXBatch</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function contains(command : PXCommand) : Boolean
		{
			return aCommands.indexOf(command) != -1;
		}

		/**
		 * Starts the execution of the batch. The received event 
		 * is registered and then passed to sub commands.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onExecute(event : Event = null) : void
		{
			if ( !bCommandProcessing && length > 0 )
			{
				eEvent = event;
				nIndex = 0;
				fireStartEvent();
				executeNextCommand(eEvent);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function onCancel() : void
		{
		}

		/**
		 * Called when the command process is beginning.
		 * 
		 * @param	event	<code>PXCommandEvent</code> dispatched by the command.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onCommandStart(event : PXCommandEvent) : void
		{
			bCommandProcessing = true;
		}

		/**
		 * Called when the command process is over.
		 * 
		 * @param	event	<code>PXCommandEvent</code> dispatched by the command.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onCommandEnd(event : PXCommandEvent) : void
		{
			bCommandProcessing = false;

			aCommands[ nIndex ].removeCommandListener(this);

			if ( nIndex + 1 < length )
			{
				nIndex++;
				executeNextCommand(event);
			}
			else
			{
				nIndex = 0;
				fireEndEvent();
				fireCommandEndEvent();
			}
		}

		/**
		 * Returns the <code>PXCommand</code> that running at this time in the sequencer.
		 * 
		 * @return the <code>PXCommand</code> that running at this time in the sequencer
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getRunningCommand() : PXCommand
		{
			if ( running )
			{
				return aCommands[ nIndex ];
			}
			else
			{
				throw new PXIllegalStateException("getRunningCommand() cannot be called when the sequencer is not running", this);
				return null ;
			}
		}

		/**
		 * Removes all commands stored in the batch stack.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			if ( !running )
			{
				aCommands = new Vector.<PXCommand>();
			}
		}

		/**
		 * Adds a listener that will be notified about sequencer process.
		 * 
		 * @param	listener	<code>PXSequencerListener</code> that will receive events.
		 * 
		 * @return	<code>true</code> if the listener has been added
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addListener(listener : PXSequencerListener) : Boolean
		{
			return oEB.addListener(listener);
		}

		/**
		 * Removes listener from receiving any sequencer information.
		 * 
		 * @param	listener	<code>PXSequencerListener</code> to remove.
		 * 
		 * @return	<code>true</code> if the listener has been removed
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListener(listener : PXSequencerListener) : Boolean
		{
			return oEB.removeListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		override public function toString() : String
		{
			return super.toString() + " [" + length + "]";
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * Adds passed-in command at index position in sequencer.
		 * 
		 * @param	index		Index for insertion (must be valid)
		 * @param	command		<code>command</code> to add
		 * 
		 * @return	<code>true</code> if <code>command</code> was successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function addCommandAt(index : uint, command : PXCommand) : Boolean
		{
			if ( !running  )
			{
				var length : uint = aCommands.length;

				if ( command == null || index > length) return false;

				if ( command is PXAbstractCommand ) ( command as PXAbstractCommand).owner = owner;

				aCommands.splice(index, 0, command);
				return (length != aCommands.length );
			}

			return false;
		}

		/**
		 * Executes next method, if available.
		 * 
		 * @param	event <code>Event</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function executeNextCommand(event : Event) : void
		{
			if ( nIndex == -1 )
			{
				PXDebug.WARN("process has been aborted. Can't execute next command.", this);
			}
			else
			{
				aCommands[ nIndex ].addCommandListener(this);

				var cmd : PXAbstractCommand;
				if ( ( cmd = aCommands[ nIndex ] as PXAbstractCommand ) != null ) cmd.owner = owner;

				fireProgressEvent(aCommands[ nIndex ]);

				aCommands[ nIndex ].execute(useEventFlow ? event : eEvent);
			}
		}

		/**
		 * Fires <code>onSequencerStart</code> event when sequencer starts 
		 * execution.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireStartEvent() : void
		{
			oEB.broadcastEvent(new PXObjectEvent(onSequencerStartEVENT, this, null));
		}

		/**
		 * Fires <code>onSequencerProgressEVENT</code> event when a new 
		 * command is ready to be executed.
		 * 
		 * @param	command	Command to be executed
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireProgressEvent(command : PXCommand) : void
		{
			oEB.broadcastEvent(new PXObjectEvent(onSequencerProgressEVENT, this, command));
		}

		/**
		 * Fires <code>onSequencerEnd</code> event when sequencer ends 
		 * execution.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireEndEvent() : void
		{
			oEB.broadcastEvent(new PXObjectEvent(onSequencerEndEVENT, this, null));
		}
	}
}
