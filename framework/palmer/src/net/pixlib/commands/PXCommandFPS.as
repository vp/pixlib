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
	import net.pixlib.log.PXStringifier;
	import net.pixlib.transitions.PXFPSBeacon;
	import net.pixlib.transitions.PXTickListener;

	import flash.events.Event;

	/**
	 * The PXCommandFPS class manages a Commands list to execute 
	 * on each frame (FPS).
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXCommandFPS	implements PXTickListener
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _oI : PXCommandFPS;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		protected var oCommands : Object;
		protected var oBuffer : Object;
		protected var nID : int;
		protected var nSize : int;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns execution list length.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get length() : int
		{
			return nSize;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns PXCommandFPS singleton access.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXCommandFPS
		{
			if (!_oI ) _oI = new PXCommandFPS();
			return _oI;
		}
		
		/**
		 * Releases singleton.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function release() : void
		{
			PXFPSBeacon.getInstance().removeListener(PXCommandFPS._oI);
			
			_oI.removeAll();
			_oI = null;
		}

		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXCommandFPS()
		{
			oCommands = new Object();
			oBuffer = new Object();
			nID = 0;
			nSize = 0;
			PXFPSBeacon.getInstance().addListener(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function onTick( event : Event = null ) : void
		{
			for (var s:String in oCommands) oCommands[s].execute();
		}

		/**
		 * Adds passed-in command to execution list and executes it now.
		 * 
		 * @param 	command	<code>PXCommand</code> to add.
		 * 
		 * @return 	The command identifier name in list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function push(command : PXCommand) : String
		{
			return pushCommand(command, getNameID());
		}

		/**
		 * Adds passed-in command to execution list and executes it now.
		 * 
		 * @param	command	<code>PXCommand</code> to add.
		 * @param	name	PXCommand identifier name.
		 * 
		 * @return The command identifier name in list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function pushWithName(command : PXCommand, name : String = null) : String
		{
			name = (name == null) ? getNameID() : name;
			return pushCommand(command, name);
		}
		
		/**
		 * Stores passed-in command and wait for 
		 * a loop before executes it.<br />
		 * PXCommand is removed after execution.
		 * 
		 * <p>An identifier name is automatically build</p>
		 * 
		 * @param	command	<code>PXCommand</code> to delayed
		 * 
		 * @return The command identifier name in list
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function delay(command : PXCommand) : String
		{
			var dName : String = getNameID();
			var delegate : PXDelegate = new PXDelegate(delayCommand, command, dName);
			oCommands[dName] = delegate;
			return dName;
		}
		
		/**
		 * Removes passed-in command from execution list.
		 * 
		 * @param	command	<code>PXCommand</code> to remove
		 * 
		 * @return <code>true</code> if command is removed
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function remove(command : PXCommand) : Boolean
		{
			for(var s:String in oCommands) if (oCommands[s] == command) return removeCommand(s);
			return false;
		}

		/**
		 * Removes passed-in command with identifier name from execution list.
		 * 
		 * @param	name	PXCommand identifier name.
		 * 
		 * @return <code>true</code> if command is removed
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeWithName(name : String) : Boolean
		{
			return oCommands.hasOwnProperty(name) ? removeCommand(name) : false;
		}

		/**
		 * Excludes passed-in command from execution list.
		 * 
		 * <p>PXCommand still in buffer, use <code>resume()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	command	<code>PXCommand</code> to exclude form execution list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function stop(command : PXCommand) : Boolean
		{
			for (var s:String in oCommands) if (oCommands[s] == command) return stopCommand(s);
			return false;
		}

		/**
		 * Excludes command registered with passed-in name 
		 * from execution list.
		 * 
		 * <p>PXCommand still in buffer, use <code>resumeWithName()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	name	PXCommand identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function stopWithName(name : String) : Boolean
		{
			return (oCommands.hasOwnProperty(name)) ? stopCommand(name) : false;
		}

		/**
		 * Resume commande with command occurence.
		 * 
		 * @param	name	<code>PXCommand</code> identifier name to submit to execution list.
		 * 
		 * @return <code>true</code> if command is executed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function resume(command : PXCommand) : Boolean
		{
			for (var s:String in oBuffer) if (oBuffer[s] == command) return resumeCommand(s);
			return false;
		}

		/**
		 * Resume commande with identifier name .
		 * 
		 * @param	name	PXCommand identifier name to submit to execution list.
		 * 
		 * @return <code>true</code> if command is executed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function resumeWithName(name : String) : Boolean
		{
			return (oBuffer.hasOwnProperty(name)) ? resumeCommand(name) : false;
		}

		/**
		 * Removes all commands from execution list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAll() : void
		{
			oCommands = new Object();
			oBuffer = new Object();
			nSize = 0;
		}
		
		/**
		 * Returns string representation of instance.
		 * 
		 * @return The string representation of instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}

		/**
		 * Adds passed-in command to execution list and executes it now.
		 * 
		 * @param	command	<code>PXCommand</code> to add.
		 * @param	name	PXCommand identifier name.
		 * 
		 * @return The command identifier name in list
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function pushCommand(command : PXCommand, name : String) : String
		{
			if( oCommands.hasOwnProperty(name) )
			{
				oCommands[name] = command;
			}
			else
			{
				oCommands[name] = command;
				nSize++;
			}
			
			command.execute();
			return name;
		}
		
		/**
		 * Return identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getNameID() : String
		{
			while (oCommands.hasOwnProperty('_C_' + nID)) nID++;
			return '_C_' + nID;
		}

		/**
		 * Removes command registered with passed-in identifier name.
		 * 
		 * @param	name	 <code>PXCommand</code> identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function removeCommand(name : String) : Boolean
		{
			delete oCommands[name];
			nSize--;
			return true;
		}

		/**
		 * Excludes passed-in command from execution list.
		 * 
		 * <p>PXCommand still in buffer, use <code>resume()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	name	PXCommand identifier name to exclude form execution list.
		 * 
		 * @return <code>true</code> if command is stopped.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function stopCommand(name : String) : Boolean
		{
			oBuffer[name] = oCommands[name];
			delete oCommands[name];
			return true;
		}
		
		/**
		 * Submits passed-in command into execution list.
		 * 
		 * @param	name	PXCommand identifier name to submit to execution list.
		 * 
		 * @return <code>true</code> if command is executed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function resumeCommand(name : String) : Boolean
		{
			var command : PXCommand = oBuffer[name];
			delete oBuffer[name];
			command.execute();
			oCommands[name] = command;
			return true;
		}

		/**
		 * Execute a delay call.
		 * 
		 * @param	command	<code>PXCommand</code> to execute.
		 * @param	name	PXCommand identifier identifier.
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function delayCommand(command : PXCommand, name : String) : void
		{
			removeWithName(name);
			command.execute();
		}
	}
}