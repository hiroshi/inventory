module HttpError
  class BadRequestError < Exception; end
  class ForbiddenError < Exception; end
  class NotFoundError < Exception; end
end
