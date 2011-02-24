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
package net.pixlib.commands {
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.events.PXEventBroadcaster;
	import net.pixlib.exceptions.PXIllegalStateException;
	import net.pixlib.exceptions.PXUnimplementedMethodException;
	import net.pixlib.log.PXLog;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.model.PXModel;
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginDebug;
	import net.pixlib.view.PXView;
	import flash.events.Event;

	/**
	 *  Dispatched when command process is beginning.
	 *  
	 *  @eventType net.pixlib.events.PXCommandEvent.onCommandStartEVENT
	 */
	[Event(name="onCommandStart", type="net.pixlib.events.PXCommandEvent")]
	
	/**
	 *  Dispatched when command process is over.
	 *  
	 *  @eventType net.pixlib.events.PXCommandEvent.onCommandEndEVENT
	 */
	[Event(name="onCommandEnd", type="net.pixlib.events.PXCommandEvent")]
	
	/**
	 * <code>PXAbstractCommand</code> provides a skeleton for commands which
	 * might work within plugin's <code>PXFrontController</code>. Abstract command
	 * provides methods which allow the <code>PXFrontController</code> to set
	 * the command owner at the command creation. Additionally the 
	 * <code>PXAbstractCommand</code> class provides convenient method to access
	 * all MVC components and logging tools of the plugin owner.
	 * <p>
	 * pixLib encourage the creation of stateless commands, it means
	 * that commands must realize all their process entirely in
	 * the <code>execute</code> call. The constructor of a stateless
	 * command should always be empty.
	 * </p><p>
	 * See the <a href="../../../howto/howto-commands.html">How to use
	 * the Command pattern implementation in pixLib</a> document for more details
	 * on the commands package structure.
	 * </p>
	 * 
	 * @author	Francis Bourre
	 * @author 	Cédric Néhémie
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXAbstractCommand implements PXCommand, PXCancelable
	{
		private var _owner : PXPlugin;
		private var _bIsRunning : Boolean;
		private var _bIsCancelled : Boolean;

		protected var oEB : PXEventBroadcaster;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * A reference to the owner of this command.
		 * 
		 * @return	the plugin owner of this command
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get owner() : PXPlugin
		{
			return _owner;
		}
		
		/**
		 * @private
		 */	
		public function set owner(value : PXPlugin) : void
		{
			_owner = value;
		}

		/**
		 * Returns the exclusive Log object owned by the plugin.
		 * It allows this command to send logging message directly on
		 * its owner logging channel.
		 * 
		 * @return	PXLog associated to the owner
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get logger() : PXLog
		{
			return PXPluginDebug.getInstance(owner);
		}
		
		/**
		 * Processing state of current command.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function get running() : Boolean
		{
			return _bIsRunning;
		}
		
		/**
		 * @inheritDoc
		 */
		final public function get cancelled() : Boolean
		{
			return _bIsCancelled;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		function PXAbstractCommand() 
		{
			_bIsRunning = false;
			_bIsCancelled = false;
			oEB = new PXEventBroadcaster(this);
			_owner = PXBasePlugin.getInstance();
		}
		
		/**
		 * Execute a request.
		 * <p>
		 * If execution can't be performed, the command must throw an error.
		 * </p> 
		 * @param	e	An event that will contain data to help command execution. 
		 * @throws 	<code>PXUnreachableDataException</code> — Sometimes commands use event 
		 * argument as data container to help process execution. In this case the event 
		 * must transport expected data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function execute( event : Event = null ) : void 
		{
			var msg : String;

			if ( running )
			{
				msg = "execute() failed. This command is already processing.";
				msg += " It cannot be called twice. Next call must wait for fireCommandEndEvent() call.";
				throw new PXIllegalStateException(msg, this);
			} 
			else if ( cancelled )
			{
				msg = "execute() failed. This command has been cancelled.";
				throw new PXIllegalStateException(msg, this);
			} 
			else
			{
				fireCommandStartEvent();

				try
				{
					onExecute(event);
				} 
				catch ( exception : Error )
				{
					logger.error("execute() failed. " + exception.message, this);
					fireCommandEndEvent();
					throw exception;
				}
			}
		}

		/**
		 * Fires <code>onCommandStart</code> event to each listener when
		 * process is beginning. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function fireCommandStartEvent() : void
		{
			_bIsRunning = true;
			broadcastCommandStartEvent();
		}

		/**
		 * Fires <code>onCommandEnd</code> event to each listener when
		 * process is over. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function fireCommandEndEvent() : void
		{
			if ( _bIsRunning )
			{
				_bIsRunning = false;
				broadcastCommandEndEvent();
			} 
			else
			{
				logger.warn("fireCommandEndEvent() failed (this command was not running)", this);
			}
		}

		/**
		 * Adds a listener that will receive a start event <code>
		 * PXAbstractCommand.onCommandStartEVENT</code> each time  
		 * command process is beginning and an end event <code>
		 * PXAbstractCommand.onCommandEndEVENT</code> each time when 
		 * command process is over.
		 * <p>
		 * The <code>addListener</code> method supports custom arguments
		 * provided by <code>PXEventBroadcaster.addEventListener()</code> method.
		 * </p> 
		 * @param	listener	listener that will receive events
		 * @param	rest		optional arguments
		 * @return	<code>true</code> if the listener has been added to
		 * 			receive both events.
		 * @see		net.pixlib.events.PXEventBroadcaster#addEventListener()
		 * 			PXEventBroadcaster.addEventListener() documentation
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addCommandListener( listener : PXCommandListener, ... rest ) : Boolean
		{
			return (oEB.addEventListener.apply(oEB, rest.length > 0 
				? [PXCommandEvent.onCommandStartEVENT, listener].concat(rest) 
				: [PXCommandEvent.onCommandStartEVENT, listener]) && oEB.addEventListener.apply(oEB, rest.length > 0 
					? [PXCommandEvent.onCommandEndEVENT, listener].concat(rest) 
					: [PXCommandEvent.onCommandEndEVENT, listener]));
		}

		/**
		 * Removes listener from receiving any start and end process 
		 * information.
		 * 
		 * @param	listener	listener to remove
		 * @return	<code>true</code> if the listener has been removed to
		 * 			receive both events.
		 * @see		net.pixlib.events.PXEventBroadcaster#addEventListener()
		 * 			PXEventBroadcaster.addEventListener() documentation
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeCommandListener( listener : PXCommandListener ) : Boolean
		{
			return (oEB.removeEventListener(PXCommandEvent.onCommandStartEVENT, listener) && oEB.removeEventListener(PXCommandEvent.onCommandEndEVENT, listener));
		}
		
		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#addEventListener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addEventListener( type : String, listener : Object, ... rest ) : Boolean
		{
			return oEB.addEventListener.apply(oEB, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}
		
		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#removeEventListener
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeEventListener( type : String, listener : Object ) : Boolean
		{
			return oEB.removeEventListener(type, listener);
		}

		/**
		 * Returns a reference to the model <code>PXAbstractModel</code>.
		 * It allows this command to locate any model registered to
		 * owner's <code>PXModelLocator</code>.
		 * 
		 * @param	model's key
		 * @return	a reference to the model registered with key argument
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getModel( key : String ) : PXModel
		{
			return owner.getModel(key);
		}

		/**
		 * Returns a reference to the view <code>PXAbstractView</code>.
		 * It allows this command to locate any view registered to
		 * owner's <code>PXViewLocator</code>.
		 * 
		 * @param	view's key
		 * @return	a reference to registered view
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getView( key : String ) : PXView
		{
			return owner.getView(key);
		}

		/**
		 * Check if a model <code>PXAbstractModel</code> is registered
		 * with passed key in owner's <code>PXModelLocator</code>.
		 * 
		 * @param	model's key
		 * @return	true if model a model <code>PXAbstractModel</code> is registered.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isModelRegistered( key : String ) : Boolean
		{
			return owner.isModelRegistered(key);
		}

		/**
		 * Check if a view <code>PXAbstractView</code> is registered
		 * with passed key in owner's <code>PXViewLocator</code>.
		 * 
		 * @param	view's key
		 * @return	true if model a view <code>PXAbstractView</code> is registered.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isViewRegistered( key : String ) : Boolean
		{
			return owner.isViewRegistered(key);
		}

		/**
		 * Implementation of the <code>PXRunnable</code> interface. 
		 * A call to <code>run()</code> is equivalent to a call to
		 * <code>execute</code> without any argument.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function run() : void
		{
			execute();
		}

		/**
		 * Attempts to cancel command execution.
		 * This attempt will fail if the command has been already completed,
		 * has been already cancelled, or could not be cancelled for
		 * any reason. If cancellation is successful, and this command has 
		 * not started when cancel is called, this command should never run 
		 * later.
		 * <p>
		 * After this method call, subsequent calls to <code>isRunning</code>
		 * will always return <code>false</code>. Subsequent calls to
		 * <code>run</code> will always fail with an exception. Subsequent
		 * calls to <code>cancel</code> will always failed with the throw
		 * of an exception. 
		 * </p>
		 * @throws 	<code>PXIllegalStateException</code> — if the <code>cancel</code>
		 * 			method has been called wheras the operation has been already
		 * 			cancelled
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final public function cancel() : void
		{
			if ( cancelled )
			{
				throw new PXIllegalStateException(this + ".cancel() illegal call. This command has been already cancelled.", this);
			} 
			else
			{
				try
				{
					_bIsCancelled = true;
					onCancel();
					fireCommandEndEvent();
				} 
				catch ( exception : PXUnimplementedMethodException )
				{
					_bIsCancelled = false;
					throw exception;
				}
			}
		}

		/**
		 * Returns the string representation of the object.
		 * 
		 * @return the string representation of the object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		/**
		 * Fires a private event in the scope of the plugin. 
		 * 
		 * @param event Event to fire.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function firePrivateEvent( event : Event ) : void
		{
			owner.firePrivateEvent(event);
		}

		/**
		 * Sends to each listener <code>PXAbstractCommand.onCommandStartEVENT</code>
		 * when process is beginning. Override this method if you need 
		 * to change the message broadcasted. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function broadcastCommandStartEvent() : void
		{
			oEB.broadcastEvent(new PXCommandEvent(PXCommandEvent.onCommandStartEVENT, this));
		}

		/**
		 * Sends to each listener <code>PXAbstractCommand.onCommandEndEVENT</code>
		 * when process is over. Override this method if you need to
		 * change the message broadcasted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function broadcastCommandEndEvent() : void
		{
			oEB.broadcastEvent(new PXCommandEvent(PXCommandEvent.onCommandEndEVENT, this));
		}

		/**
		 * Override this method in concrete class to implement command 
		 * execution. 
		 * 
		 * @param event Event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onExecute( event : Event = null ) : void
		{
			throw new PXUnimplementedMethodException(".onExecute() must be implemented in concrete class to allow execute() call.", this);
		}

		/**
		 * Override this method in concrete class to implement cancel 
		 * behavior. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onCancel() : void
		{
			throw new PXUnimplementedMethodException(".onCancel() must be implemented in concrete class to allow cancel() call.", this);
		}
	}
}