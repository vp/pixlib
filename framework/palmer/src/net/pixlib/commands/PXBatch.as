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

	/**
	 * <code>PXBatch</code> object encapsulate a set of <code>PXCommands</code>
	 * to execute.
	 * 
	 * <p>Default, PXBatch is a first-in first-out stack (FIFO) where commands
	 * are executed in the order they were registered.<br />
	 * Batch can be LIFO using Batch instanctiation 2nd argument.</p>
	 * 
	 * <p>Default, the <code>Event</code> object received in the 
	 * <code>execute</code> is passed to each commands contained in this 
	 * batch.<br />
	 * But you can relay event from command to command using Batch 
	 * <code>instanciaton</code> first argument.
	 * </p>
	 * 
	 * <p>The PXBatch class extends <code>PXAbstractCommand</code>
	 * and so, dispatch an <code>onCommandEnd</code> event at the execution end
	 * of all commands.</p> 
	 * 
	 * @author Cédric Néhémie
	 * @author Francis Bourre	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXBatch	extends PXAbstractCommand 
						implements PXMacroCommand, PXCommandListener
	{

		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
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
		protected var nIndex : Number;

		/** 
		 * Main source event data.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var eEvent : Event;

		/** 
		 * Last executed command.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oLastCommand : PXCommand;
		
		/**
		 *  Indicates if Batch use command event flow or only 
		 *  source event data.
		 *  
		 *  <p>If <code>true</code> next command is executed using 
		 *  last command event result.<br />
		 *  If <code>false</code>, only use the main source event data 
		 *  passed-in Batch.execute() call.</p>
		 *  
		 *  @default false
		 *   
		 *  @see #Batch()
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bUseEventFlow : Boolean;
		
		/**
		 * Defines command list execution order.
		 * 
		 * <p>Default is FIFO mode (<code>false</code>).<br />
		 * Sets to <code>true</code> to use LIFO mode.</p>
		 * 
		 * @default false
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bReversed : Boolean;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		
		/**
		 * @inheritDoc
		 */
		override public function set owner( value : PXPlugin ) : void
		{
			super.owner = value;
			
			var length : Number = aCommands.length;
			var cmd : PXAbstractCommand;
			while( --length - (-1 ) ) if( ( cmd = aCommands[ length ] as PXAbstractCommand ) != null ) cmd.owner = owner;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Takes all elements of an Array and pass them one by one as arguments
		 * to a method of an object.
		 * It's exactly the same concept as batch processing in audio or video
		 * software, when you choose to run the same actions on a group of files.
		 * <p>
		 * Basical example which sets _alpha value to 0.4 and scale to 0.5
		 * on all MovieClips nested in the Array :
		 * </p>
		 * @example
		 * <listing>
		 * import net.pixlib.commands.*;
		 *
		 * function changeAlphaAndScale( mc : MovieClip, a : Number, s : Number )
		 * {
		 *      mc.alpha = a;
		 *      mc.scaleX = mc.scaleY = s;
		 * }
		 *
		 * PXBatch.process( changeAlphaAndScale, [mc0, mc1, mc2], .4, 0.5 );
		 * </listing>
		 *
		 * @param	method	function to run.
		 * @param	targets	array of parameters.
		 * @param 	args	additionnal parameters to concat with the passed-in
		 * 					arguments array
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function process( method : Function, targets : Array, ...args ) : void
		{
			var length : Number = targets.length;
			for( var i : int; i < length ; i++ ) 
			{
				method.apply( null, (args.length > 0 ) 
					? [ targets[i] ].concat( args ) 
					: [ targets[i] ] );
			}
		}

		/**
		 * Creates a new batch object.
		 * 
		 * @param useEventFlow	 
		 * @param reversed		
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXBatch( useEventFlow : Boolean = false, reversed : Boolean = false )
		{
			aCommands = new Vector.<PXCommand>( );
			
			bUseEventFlow = useEventFlow;			bReversed = reversed;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addCommand( command : PXCommand ) : Boolean
		{
			if( command == null ) return false;
			if( command is PXAbstractCommand ) ( command as PXAbstractCommand).owner = owner;
			var length : uint = aCommands.length;
			return (length != aCommands.push( command ) );
		}

		/**
		 * @inheritDoc
		 */
		public function removeCommand( command : PXCommand ) : Boolean
		{
			var index : int = aCommands.indexOf( command ); 
			if ( index == -1 ) return false;
			while ( ( index = aCommands.indexOf( command ) ) != -1 ) aCommands.splice( index, 1 );
			return true;
		}

		/**
		 * Returns <code>true</code> if the passed-in command is stored
		 * in this batch.
		 * 
		 * @param	command PXCommand object to look at
		 * @return	<code>true</code> if the passed-in command is stored
		 * 		   	in the <code>Batch</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function contains( command : PXCommand ) : Boolean
		{
			return aCommands.indexOf( command ) != -1;
		}
		
		/**
		 * Starts the execution of the batch. The received event 
		 * is registered and then passed to sub commands.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onExecute( e : Event = null ) : void
		{
			eEvent = e;
			nIndex = -1;

			if( bReversed ) aCommands.reverse();
			if( hasNext( ) ) next( ).execute( eEvent );
		}
		
		/**
		 * @inheritDoc
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onCancel() : void
		{
			
		}
		
		/**
		 * Called when the command process is beginning.
		 * 
		 * @param	event	event dispatched by the command
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onCommandStart( event : PXCommandEvent ) : void
		{
			
		}

		/**
		 * Called when the command process is over.
		 * 
		 * @param	event	event dispatched by the command
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onCommandEnd( event : PXCommandEvent ) : void
		{
			if( hasNext( ) )
			{
				next( ).execute( bUseEventFlow ? event : eEvent );

			}  else
			{
				fireCommandEndEvent();
			}
		}

		/**
		 * Removes all commands stored in the batch stack.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAll() : void
		{
			aCommands = new Vector.<PXCommand>( );
		}

		/**
		 * Returns the number of commands stored in this batch.
		 * 
		 * @return	the number of commands stored in this batch
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function size() : uint
		{
			return aCommands.length;		
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Returns the next command to execute.
		 * 
		 * @return 	the next command to execute
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function next() : PXCommand
		{
			if( oLastCommand ) oLastCommand.removeCommandListener( this );
			oLastCommand = aCommands.shift( ) as PXCommand;
			oLastCommand.addCommandListener( this );
			return oLastCommand;
		}
		
		/**
		 * Returns <code>true</code> if there is a command
		 * left to execute.
		 * 
		 * @return	<code>true</code> if there is a command
		 * 			left to execute
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function hasNext() : Boolean
		{
			return nIndex + 1 < aCommands.length;
		}
	}
}
