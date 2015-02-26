define (require) ->
  describe 'Inbox folder', ->
    beforeEach ->
      @Inbox = require('../../../../../build/app/Models/Folder/Inbox')
      @Mailbox = require('../../../../../build/app/Models/Mailbox')
      @mailbox = new @Mailbox('whatever')

    describe 'Criterion', ->
      beforeEach ->
        @Criterion = @Inbox.Criterion
        @criterion = new @Criterion(@mailbox)

        @Message = require('../../../../../build/app/Models/Message/Message')
        @message = new @Message()

        sinon.stub @message, 'getRecipients'
          .returns ['whatso@ever.ly']

        @TrashLabel = require('../../../../../build/app/Models/Message/Label/TrashLabel')

      describe 'test', ->
        it 'should throw if argument is not a message', ->
          expect => @criterion.test('blah')
          	.to.throwError (err) ->
              expect err.message
              	.to.be 'Criterion should be tested against a Message'

        it 'should return true if message is directed to own address and not in trash', ->
          sinon.stub @mailbox, 'isOwnAddress'
            .returns true

          sinon.stub @message, 'hasLabelByType'
            .withArgs @TrashLabel
            .returns false

          expect @criterion.test @message
            .to.be true

        it 'should return false if message has Trash label', ->
          sinon.stub @mailbox, 'isOwnAddress'
            .returns true

          sinon.stub @message, 'hasLabelByType'
            .withArgs @TrashLabel
            .returns true

          expect @criterion.test @message
          	.to.be false

        it 'should return false if message is not directed to own address', ->
          sinon.stub @mailbox, 'isOwnAddress'
            .returns false

          sinon.stub @message, 'hasLabelByType'
            .withArgs @TrashLabel
            .returns false

          expect @criterion.test @message
          	.to.be false

        it 'should return false if message has no recipients', ->
          @message.getRecipients.returns []
          expect @criterion.test @message
            .to.be false
