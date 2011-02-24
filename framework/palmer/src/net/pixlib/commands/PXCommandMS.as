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

	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	

	/**
	 * The PXCommandMS class manages a Commands list to execute 
	 * on using timer tick.
	 * 
	 * @author 	Francis Bourre
	 * 			
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXCommandMS
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private static var _oI : PXCommandMS;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		protected var oCommands : Object;
		protected var nID : int;
		protected var nSize : int;

		protected static var EXT : String = '_C_';

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Execution list length.
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
		 * Returns PXCommandMS singleton access.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXCommandMS
		{
			if (!_oI) _oI = new PXCommandMS();
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
			_oI.removeAll();
			_oI = null;
		}

		/**
		 * Creates new instance.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXCommandMS()
		{
			oCommands = new Object();
			nID = 0;
			nSize = 0;
		}

		/**
		 * Registers passed-in command.
		 * 
		 * @param	command	<code>PXCommand</code> to push
		 * @param	time	PXCommand execution timer
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function push(command : PXCommand, time : Number) : String
		{
			var cmdName : String = getNameID();
			if (oCommands.hasOwnProperty(cmdName)) removeCommand(cmdName);
			
			return pushCommand(command, time, cmdName);
		}

		/**
		 * Registers passed-in command with passed-in name.
		 * 
		 * @param	command	<code>PXCommand</code> to push.
		 * @param	time	PXCommand execution timer.
		 * @param	name	PXCommand identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function pushWithName(command : PXCommand, time : Number, name : String = null) : String
		{
			if (name == null) 
			{
				name = getNameID();
			} 
			else if (oCommands.hasOwnProperty(name)) 
			{
				removeCommand(name);
			}
			
			return pushCommand(command, time, name);
		}

		/**
		 * Executes a delay call.
		 * 
		 * @param	command	<code>PXCommand</code> to execute
		 * @param	time	PXCommand identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function delay(command : PXCommand, time : Number) : String
		{
			var cmdName : String = getNameID();
			var cmdVO : Object = oCommands[cmdName] = new Object();
			cmdVO.cmd = command;
			cmdVO.ID = setInterval(delayCommand, time, cmdName);
			
			return cmdName;
		}

		/**
		 * Removes passed-in command.
		 * 
		 * @param	command	<code>PXCommand</code> to remove.
		 * 
		 * @return <code>true</code> if command is removed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function remove(command : PXCommand) : Boolean
		{
			for (var s:String in oCommands) if (oCommands[s].cmd == command) return removeCommand(s);
			return false;
		}

		/**
		 * Removes passed-in command with passed-in name.
		 * 
		 * @param	name	PXCommand identifier name.
		 * 
		 * @return <code>true</code> if command is removed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeWithName(name : String) : Boolean
		{
			return (oCommands.hasOwnProperty(name)) ? removeCommand(name) : false;
		}

		/**
		 * Excludes command registered from execution list.
		 * 
		 * <p>PXCommand still in buffer, use <code>resume()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	command	<code>PXCommand</code>.
		 * 
		 * @return <code>true</code> if command is stopped.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function stop(command : PXCommand) : Boolean
		{
			for (var s:String in oCommands) if (oCommands[s].cmd == command) return stopCommand(s);
			return false;
		}

		/**
		 * Excludes command registered passed-in command with passed-in name from execution list..
		 * 
		 * <p>PXCommand still in buffer, use <code>resumeWithName()</code> to 
		 * replace command in execution list.</p>
		 * 
		 * @param	name	PXCommand identifier name.
		 * 
		 * @return <code>true</code> if command is stopped.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function stopWithName(name : String) : Boolean
		{
			return (oCommands.hasOwnProperty(name)) ? stopCommand(name) : false;
		}

		/**
		 * Submits passed-in command into execution list.
		 * 
		 * @param	command	<code>PXCommand</code> to submit to execution list.
		 * 
		 * @return <code>true</code> if command is executed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function resume(command : PXCommand) : Boolean
		{
			for (var s:String in oCommands) if (oCommands[s].cmd == command) return notifyCommand(s);
			return false;
		}

		/**
		 * Submits passed-in command into execution list.
		 * 
		 * @param	command	<code>PXCommand</code> to submit to execution list.
		 * 
		 * @return <code>true</code> if command is executed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function resumeWithName(name : String) : Boolean
		{
			return (oCommands.hasOwnProperty(name)) ? notifyCommand(name) : false;
		}

		/**
		 * Removes all objects from execution list and from buffer.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAll() : void
		{
			for (var s:String in oCommands) removeCommand(s);
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

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------

		/**
		 * Registers passed-in command with passed-in name.
		 * 
		 * @param	command	<code>PXCommand</code> to push.
		 * @param	time	PXCommand execution timer.
		 * @param	name	PXCommand identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function pushCommand(command : PXCommand, time : Number, name : String) : String
		{
			var cmdVO : Object = new Object();
			cmdVO.cmd = command;
			cmdVO.ms = time;
			cmdVO.ID = setInterval(command.execute, time);
			oCommands[name] = cmdVO;
			nSize++;
			
			command.execute();
			
			return name;
		}

		/**
		 * Returns a unique identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getNameID() : String
		{
			while (oCommands.hasOwnProperty(PXCommandMS.EXT + nID)) nID++;
			return PXCommandMS.EXT + nID;
		}

		/**
		 * Remove passed-in command with passed-in identifier name.
		 * 
		 * @param	command	<code>PXCommand</code> to push.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function removeCommand(name : String) : Boolean
		{
			clearInterval(oCommands[name].ID);
			delete oCommands[name];
			nSize--;
			return true;
		}

		/**
		 * Excludes passed-in command registered with passed-in identifier name from execution list.
		 * 
		 * @param	command	<code>PXCommand</code> to push.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function stopCommand(name : String) : Boolean
		{
			clearInterval(oCommands[name].ID);
			return true;
		}

		/**
		 * Adds command registered with passed-in identifier name into 
		 * execution list.
		 * 
		 * @param	name	PXCommand identifier name.
		 * 
		 * @return <code>true</code> if command is executed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function notifyCommand(name : String) : Boolean
		{
			oCommands[name].ID = setInterval(PXCommand(oCommands[name].cmd).execute, oCommands[name].ms);
			return true;
		}

		/**
		 * Executes delay call of command registered with passed-in identifier name into 
		 * execution list.
		 * 
		 * @param	name	PXCommand identifier name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function delayCommand(name : String) : void
		{
			var cmdVO : Object = oCommands[name];
			clearInterval(cmdVO.ID);
			cmdVO.cmd.execute();
			delete oCommands[name];
		}
	}
}