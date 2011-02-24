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
	/**
	 * <code>PXCancelable</code> defines rules for <code>PXRunnable</code>
	 * implementations whose instances process could be cancelled.
	 * Implementers should consider the possibility for the user of the class
	 * to cancel or not the operation, if the operation could be cancelled,
	 * the implementer should create a <code>PXCancelable</code> class.
	 * <p>
	 * More formally, an operation is cancelable if there is a need for the
	 * operation to abort during its process, or if the operation couldn't be
	 * paused(stopped) and resumed(re-started) without breaking the state of
	 * the process For example, a loading process could be stopped by an
	 * action of the user.  
	 * </p><p>
	 * Implementing the <code>PXCancelable</code> interface doesn't require anything
	 * regarding the time outflow approach. The only requirements concerned the cancelable
	 * nature of the process. 
	 * </p><p>
	 * Note : There's no restriction concerning class which would implements both <code>PXSuspendable</code>
	 * and <code>PXCancelable</code> interfaces.
	 * </p> 
	 * @author 	Cédric Néhémie
	 * @see		PXRunnable
	 * @see		PXSuspendable
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public interface PXCancelable extends PXRunnable
	{
		/**
		 * Operation have been stopped as a result of a 
		 * <code>cancel</code> method call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get cancelled () : Boolean;
		
		/**
		 * Attempts to cancel execution of this task.
		 * This attempt will fail if the task has already completed,
		 * has already been cancelled, or could not be cancelled for
		 * some other reason. If successful, and this task has not
		 * started when cancel is called, this task should never run.
		 * <p>
		 * After this method returns, subsequent calls to <code>isRunning</code>
		 * will always return <code>false</code>. Subsequent calls to
		 * <code>run</code> will always fail with an exception. Subsequent
		 * calls to <code>cancel</code> will always failed with the throw
		 * of an exception. 
		 * </p>
		 * @throws 	<code>PXIllegalStateException</code> — if the <code>cancel</code>
		 * 			method have been called wheras the operation have been already
		 * 			cancelled
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function cancel() : void;
	}
}
