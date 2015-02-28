define (require) ->
  describe 'Sent folder', ->
    beforeEach ->
      @Inbox = require('../../../../../build/app/Models/Folder/Sent')
      @Mailbox = require('../../../../../build/app/Models/Mailbox')
      @mailbox = new @Mailbox('whatever')

    describe 'Criterion', ->
      beforeEach ->
        @Criterion = @Inbox.Criterion
        @criterion = new @Criterion(@mailbox)

        @Message = require('../../../../../build/app/Models/Message/Message')
        @message = new @Message()

        @from = 'arseny@smoogly.ru'
        sinon.stub @message, 'getFrom'
          .returns @from

        @TrashLabel = require('../../../../../build/app/Models/Message/Label/TrashLabel')

      describe 'test', ->
        it 'should throw if argument is not a message', ->
          expect => @criterion.test('blah')
          	.to.throwError (err) ->
              expect err.message
              	.to.be 'Criterion should be tested against a Message'

        it 'should return true if message author is a mailbox owner and message is not in trash', ->
          sinon.stub @mailbox, 'isOwnAddress'
            .withArgs @from
            .returns true

          sinon.stub @message, 'hasLabelByType'
            .withArgs @TrashLabel
            .returns false

          expect @criterion.test @message
            .to.be true

        it 'should return false if message has Trash label', ->
          sinon.stub @mailbox, 'isOwnAddress'
            .withArgs @from
            .returns true

          sinon.stub @message, 'hasLabelByType'
            .withArgs @TrashLabel
            .returns true

          expect @criterion.test @message
          	.to.be false
